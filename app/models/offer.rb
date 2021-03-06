class Offer < ApplicationRecord
    belongs_to :application, 
        class_name: 'Application', 
        foreign_key: :application_id,
        optional: true

    belongs_to :job, 
        class_name: 'Job', 
        foreign_key: :job_id, 
        optional: true


    def self.test_method(year, month)
        offers = Offer.joins(:job).where("extract(year from offers.created_at) = ? AND
                            extract(month from offers.created_at) = ? AND
                            (offers.custom_fields ->> 'employment_type' = ? OR jobs.custom_fields ->> 'employment_type' = ?) AND
                            offers.status != ? AND 
                            offers.job_id NOT IN (?)", year, month, 'Full-time', 'Full-time', 'deprecated', FILTERED_JOB_IDS)
    end

    def self.get_accepted_offers_for_month_in_year(year, month)
        Offer.joins(:job).where("extract(year from offers.resolved_at) = ? AND
                    extract(month from offers.resolved_at) = ? AND
                    offers.status = ? AND 
                    (offers.custom_fields ->> 'employment_type' = ? OR jobs.custom_fields ->> 'employment_type' = ?) AND
                    offers.job_id NOT IN (?)", year, month, 'accepted', 'Full-time', 'Full-time', FILTERED_JOB_IDS)
    end

    def self.get_accepted_offers_for_year_ordered_by_months(year)
        offers = Offer.joins(:job).where("extract(year from offers.resolved_at) = ? AND
                            offers.status = ? AND
                            (offers.custom_fields ->> 'employment_type' = ? OR jobs.custom_fields ->> 'employment_type' = ?) AND
                            offers.job_id NOT IN (?)", year, 'accepted', 'Full-time', 'Full-time', FILTERED_JOB_IDS)
        offers.group_by_month(:resolved_at).count.map{ |k,v| [k.month, v] }.to_h
    end

    def self.get_accepted_offers_ordered_by_years(years)
        offers = Offer.joins(:job).where("extract(year from offers.resolved_at) IN (?) AND
                            offers.status = ? AND
                            (offers.custom_fields ->> 'employment_type' = ? OR jobs.custom_fields ->> 'employment_type' = ?) AND
                            offers.job_id NOT IN (?)", years, 'accepted', 'Full-time', 'Full-time', FILTERED_JOB_IDS)
        offers.group_by_year(:resolved_at).count.map{ |k,v| [k.year, v] }
    end

    #NOTE: offers accepted for a given month will not always be the same as the number of hires for a given month
    # this is because an offer that is sent in June, for instance, and accepted in July will count as a hire for July. 
    # But because it was an offer that was sent out in June, it will count as an accepted offer for June.
    def self.get_offer_acceptance_ratio_data_for_month_in_year(year, month)
        data = {year: year, month: month, date: MONTH_NAMES[month] + " #{year}"}
        # make sure to not count deprecated offers
        offers = Offer.joins(:job).where("extract(year from offers.created_at) = ? AND
                            extract(month from offers.created_at) = ? AND
                            (offers.custom_fields ->> 'employment_type' = ? OR jobs.custom_fields ->> 'employment_type' = ?) AND
                            offers.status != ? AND 
                            offers.job_id NOT IN (?)", year, month, 'Full-time', 'Full-time', 'deprecated', FILTERED_JOB_IDS).count
        # numerator in the ratio
        accepted_offers = Offer.joins(:job).where("extract(year from offers.created_at) = ? AND
                                                           extract(month from offers.created_at) = ? AND
                                                           (offers.custom_fields ->> 'employment_type' = ? OR jobs.custom_fields ->> 'employment_type' = ?) AND 
                                                           offers.job_id NOT IN (?) AND
                                                           offers.status = ?", year, month, 'Full-time', 'Full-time', FILTERED_JOB_IDS, 'accepted').count
        data[:offers] = offers
        data[:accepted_offers] = accepted_offers
        ratio = accepted_offers / offers.to_f 
        data[:ratio] = ratio.nan? || ratio == 0.0 ? 0.0 : (ratio * 100).round / 100.0
        return data                                                
    end

    def self.get_offer_acceptance_ratios_for_year_ordered_by_months(year)
        # make sure to not count deprecated offers as that'll lead to double counting
        offers = Offer.joins(:job).where("extract(year from offers.created_at) = ? AND
                            (offers.custom_fields ->> 'employment_type' = ? OR jobs.custom_fields ->> 'employment_type' = ?) AND
                            offers.status != ? AND 
                            offers.job_id NOT IN (?)", year, 'Full-time', 'Full-time', 'deprecated', FILTERED_JOB_IDS)
        # get all offers that were accepted for a given year
        accepted_offers = Offer.joins(:job).where("extract(year from offers.created_at) = ? AND
                                                (offers.custom_fields ->> 'employment_type' = ? OR jobs.custom_fields ->> 'employment_type' = ?) AND
                                                offers.job_id NOT IN (?) AND
                                                offers.status = ?", year, 'Full-time', 'Full-time', FILTERED_JOB_IDS, 'accepted')
        # group accepted offers by month and store in hash
        accepted_offers = accepted_offers.group_by_month("offers.created_at").count.map{ |k,v| [k.month, v] }.to_h
        # group offers by month and store in hash
        monthly_data = offers.group_by_month("offers.created_at").count.map{ |k,v| [k.month, v] }.to_h
        # calculate offer-acceptance ratio for each month
        monthly_data.each do |k, v|
            number_of_accepted_offers = accepted_offers[k] ? accepted_offers[k] : 0 
            ratio = number_of_accepted_offers / v.to_f
            monthly_data[k] = ratio.nan? || ratio == 0.0 ? 0.0 : (ratio * 100).round / 100.0
        end
    end

    def self.get_offer_acceptance_ratio_data_for_year(year)
        # return @yearly_data unless @yearly_data.nil? || @yearly_data[:date] != year
        yearly_data = {date: year}
        # the denominator in the ratio.
        # make sure to not count deprecated offers; will be like double counting 
        offers = Offer.joins(:job).where("extract(year from offers.created_at) = ? AND
                            (offers.custom_fields ->> 'employment_type' = ? OR jobs.custom_fields ->> 'employment_type' = ?) AND
                            offers.status != ? AND 
                            offers.job_id NOT IN (?)", year, 'Full-time', 'Full-time', 'deprecated', FILTERED_JOB_IDS).count
        # the numerator in the ratio
        accepted_offers = Offer.joins(:job).where("extract(year from offers.created_at) = ? AND
                                                           (offers.custom_fields ->> 'employment_type' = ? OR jobs.custom_fields ->> 'employment_type' = ?) AND
                                                           offers.job_id NOT IN (?) AND
                                                           offers.status = ?", year, 'Full-time', 'Full-time', FILTERED_JOB_IDS, 'accepted').count
        yearly_data[:offers] = offers
        yearly_data[:accepted_offers] = accepted_offers
        ratio = accepted_offers / offers.to_f 
        yearly_data[:ratio] = ratio.nan? || ratio == 0.0 ? 0.0 : (ratio * 100).round / 100.0
        return yearly_data 
    end

    def self.create_year_by_year_data_object(years, monthly_data_calculator)
        # initialize empty array to store year by year data
        yearly_data = Array.new
        # initialize years to empty array if years arguments is not an array
        years ||= Array.new
        # make data hash for each year passed in as parameter
        years.each{ |year| yearly_data << { name: Integer(year) } }
        # for each year, fetch respective data
        yearly_data.each do |data| 
            year = data[:name]
            monthly_data = self.send(monthly_data_calculator, year)
            # add data key to data hash
            data[:data] = Hash.new
            # add data for missing months
            current_date = DateTime.now
            (1..12).each do |month|
                if monthly_data.key?(month)
                    data[:data][MONTH_NAMES[month]] = monthly_data[month]
                else
                    unless month > current_date.month and year == current_date.year
                        data[:data][MONTH_NAMES[month]] = 0
                    end
                end
            end 
        end
        return yearly_data
    end

    def self.get_hires_statistics_data_for_year(year)
        @statistics_data = {date: year}
        monthly_data = Offer.get_accepted_offers_for_year_ordered_by_months(year)
        # calculate average
        number_of_months = monthly_data.length
        total_hires = monthly_data.values.reduce(:+)
        @statistics_data[:average] = ((total_hires / number_of_months.to_f) * 100).round / 100.0
        # calculate median
        hires_array = monthly_data.values.sort
        hires_array_length = hires_array.length
        @statistics_data[:median] = (hires_array[(hires_array_length - 1) / 2] + hires_array[hires_array_length / 2]) / 2.0
        return @statistics_data
    end

    def self.get_most_recent_hires(count = 5)
        offers = Offer.includes(application: [:candidate], job: [:department])
                    .where("(custom_fields ->> 'employment_type' = ? OR custom_fields ->> 'employment_type' IS NULL) AND
                            job_id NOT IN (?) AND
                            status = ?", 'Full-time', FILTERED_JOB_IDS, 'accepted').order(resolved_at: :desc).limit(count)
        
        hires_return_array = Array.new
        offers.each do |offer|
            if offer.custom_fields['employment_type'] == 'Full-time' || offer.job.custom_fields['employment_type'] == 'Full-time'
                hire_hash = {offer_id: offer.id} 
                hire_hash['hire_name'] = offer.application.candidate.first_name + ' ' + offer.application.candidate.last_name
                hire_hash['guild'] = offer.job.department.name
                hire_hash['job'] = offer.job.name
                hire_hash['hire_date'] = MONTH_NAMES[offer.resolved_at.month] + ' ' + offer.resolved_at.year.to_s
                hire_hash['start_date'] = MONTH_NAMES[offer.starts_at.month] + ' ' + offer.starts_at.day.to_s + ' ' + offer.starts_at.year.to_s
                hire_hash['candidate_id'] = offer.application.candidate.id
                hires_return_array << hire_hash
            end
        end    
        return hires_return_array
    end

    def self.get_hires_by_guild_for_year(year)
        hires = Offer.joins(:job).where("extract(year from offers.resolved_at) = ? AND
                                        offers.status = ? AND 
                                        (offers.custom_fields ->> 'employment_type' = ? OR jobs.custom_fields ->> 'employment_type' = ?) AND
                                        offers.job_id NOT IN (?)", year, 'accepted', 'Full-time', 'Full-time', FILTERED_JOB_IDS).group(:department_id).count
        departments = Department.pluck(:id, :name).to_h
        hires_by_department = hires.map do |k,v| 
            name = departments[k]
            name = 'CX' if departments[k] == 'Customer Experience'
            [name, v]
        end
        hires_by_department = hires_by_department.to_h
        # merge marketing and creative
        if hires_by_department.key?('Creative')
            hires_by_department['Marketing'] += hires_by_department['Creative']
            hires_by_department.delete('Creative')
        end
        hires_by_department
    end

    def self.get_hires_by_year_for_guild(guild_name, years = []) 
        guild = Department.find_by(name: guild_name)
        years_arr = years.nil? || years.length == 0 ? Offer.group_by_year(:resolved_at).count.map{ |k,v| k.year } : years
        if guild 
            guild_ids = [guild.id]
            if guild_name == 'Marketing'
                guild_ids << Department.find_by(name: 'Creative').id 
            end
            hires = Offer.joins(:job).where("extract(year from offers.resolved_at) IN (?) AND
                                            offers.status = ? AND
                                            (offers.custom_fields ->> 'employment_type' = ? OR jobs.custom_fields ->> 'employment_type' = ?) AND
                                            offers.job_id NOT IN (?) AND
                                            jobs.department_id IN (?)", years_arr, 'accepted', 'Full-time', 'Full-time', FILTERED_JOB_IDS, guild_ids)
            hires_by_year = hires.group_by_year(:resolved_at).count.map{ |k,v| [k.year, v] }
            if hires_by_year.length < years_arr.length
                hires_by_year_hash = hires_by_year.to_h
                years_arr.each{|year| hires_by_year << [year.to_i, 0] unless hires_by_year_hash.key?(year.to_i)}
            end 
            hires_by_year.sort{|x,y| x[0] <=> y[0]}
        end
    end

    def self.get_hires_by_source_for_guild(guild_name)
        guild = Department.find_by(name: guild_name)
        if guild 
            guild_ids = [guild.id]
            if guild_name == 'Marketing'
                guild_ids << Department.find_by(name: 'Creative').id 
            end
            hires = Offer.includes(:application).joins(:job).where("offers.status = ? AND
                                                                    (offers.custom_fields ->> 'employment_type' = ? OR jobs.custom_fields ->> 'employment_type' = ?) AND
                                                                    offers.job_id NOT IN (?) AND
                                                                    jobs.department_id IN (?)", 'accepted', 'Full-time', 'Full-time', FILTERED_JOB_IDS, guild_ids)
            sources = Hash.new(0)
            hires.find_each do |hire| 
                sources[hire.application.source['public_name']] += 1
            end
            return sources
        end
    end

    def self.get_offer_acceptance_ratios_ordered_by_years_and_months(years)
        years = years.nil? ? [] : years
        Offer.create_year_by_year_data_object(years.sort.reverse, :get_offer_acceptance_ratios_for_year_ordered_by_months)
    end

    def self.get_accepted_offers_ordered_by_years_and_months(years)
        years = years.nil? ? [] : years
        Offer.create_year_by_year_data_object(years.sort.reverse, :get_accepted_offers_for_year_ordered_by_months)
    end
end
