class Offer < ApplicationRecord
    belongs_to :application, 
        class_name: 'Application', 
        foreign_key: :application_id,
        optional: true

    belongs_to :job, 
        class_name: 'Job', 
        foreign_key: :job_id, 
        optional: true

    FILTERED_JOB_ID = 571948

    # consider defining a scope
    def self.get_accepted_offers_for_month_in_year(year, month)
        Offer.where("extract(year from resolved_at) = ? AND
                    extract(month from resolved_at) = ? AND
                    status = ? AND 
                    custom_fields ->> 'employment_type' = ? AND
                    job_id != ?", year, month, 'accepted', 'Full-time', FILTERED_JOB_ID)
    end

    def self.get_accepted_offers_for_year_ordered_by_months(year)
        offers = Offer.where("extract(year from resolved_at) = ? AND
                            status = ? AND
                            custom_fields ->> 'employment_type' = ? AND
                            job_id != ?", year, 'accepted', 'Full-time', FILTERED_JOB_ID)
        offers.group_by_month(:resolved_at).count.map{ |k,v| [k.month, v] }.to_h
    end

    def self.get_accepted_offers_ordered_by_years(years)
        offers = Offer.where("extract(year from resolved_at) IN (?) AND
                            status = ? AND
                            custom_fields ->> 'employment_type' = ? AND
                            job_id != ?", years, 'accepted', 'Full-time', FILTERED_JOB_ID)
        offers.group_by_year(:resolved_at).count.map{ |k,v| [k.year, v] }
    end

    def self.get_offer_acceptance_ratio_data_for_month_in_year(year, month)
        return @data unless @data.nil? || @data[:year] != year || @data[:month] != month
        @data = {year: year, month: month, date: MONTH_NAMES[month] + " #{year}"}
        offers = Offer.where("extract(year from created_at) = ? AND
                            extract(month from created_at) = ? AND
                            custom_fields ->> 'employment_type' = ? AND
                            job_id != ?", year, month, 'Full-time', FILTERED_JOB_ID).count

        accepted_offers = Offer.joins(:application).where("extract(year from offers.created_at) = ? AND
                                                           extract(month from offers.created_at) = ? AND
                                                           offers.custom_fields ->> 'employment_type' = ? AND
                                                           offers.job_id != ? AND
                                                           offers.status = ?", year, month, 'Full-time', FILTERED_JOB_ID, 'accepted').count
        @data[:offers] = offers
        @data[:accepted_offers] = accepted_offers
        ratio = accepted_offers / offers.to_f 
        @data[:ratio] = ratio.nan? ? 0.0 : (ratio * 100).round / 100.0
        return @data                                                
    end

    def self.get_offer_acceptance_ratios_for_year_ordered_by_months(year)
        # get all full-time offers for a year, but filter out offers for jobs under 'CX FT'
        offers = Offer.where("extract(year from created_at) = ? AND
                            custom_fields ->> 'employment_type' = ? AND
                            job_id != ?", year, 'Full-time', FILTERED_JOB_ID)
        # get all offers that were accepted for a given year
        accepted_offers = Offer.joins(:application).where("extract(year from offers.created_at) = ? AND
                                                           offers.custom_fields ->> 'employment_type' = ? AND
                                                           offers.job_id != ? AND
                                                           offers.status = ?", year, 'Full-time', FILTERED_JOB_ID, 'accepted')
        # group accepted offers by month and store in hash
        accepted_offers = accepted_offers.group_by_month(:created_at).count.map{ |k,v| [k.month, v] }.to_h
        # group offers by month and store in hash
        monthly_data = offers.group_by_month(:created_at).count.map{ |k,v| [k.month, v] }.to_h
        # calculate offer-acceptance ratio for each month
        monthly_data.each do |k, v|
            number_of_accepted_offers = accepted_offers[k] ? accepted_offers[k] : 0 
            ratio = number_of_accepted_offers / v.to_f
            monthly_data[k] = ratio.nan? ? 0.0 : (ratio * 100).round / 100.0
        end
    end

    def self.get_offer_acceptance_ratio_data_for_year(year)
        return @yearly_data unless @yearly_data.nil? || @yearly_data[:year] != year
        @yearly_data = {date: year}
        offers = Offer.where("extract(year from created_at) = ? AND
                            custom_fields ->> 'employment_type' = ? AND
                            job_id != ?", year, 'Full-time', FILTERED_JOB_ID).count

        accepted_offers = Offer.joins(:application).where("extract(year from offers.created_at) = ? AND
                                                           offers.custom_fields ->> 'employment_type' = ? AND
                                                           offers.job_id != ? AND
                                                           offers.status = ?", year, 'Full-time', FILTERED_JOB_ID, 'accepted').count
        @yearly_data[:offers] = offers
        @yearly_data[:accepted_offers] = accepted_offers
        ratio = accepted_offers / offers.to_f 
        @yearly_data[:ratio] = ratio.nan? ? 0.0 : (ratio * 100).round / 100.0
        return @yearly_data 
    end

    def self.create_year_by_year_data_object(years, monthly_data_calculator)
        # initialize empty array to store year by year data
        yearly_data = Array.new
        # initialize years to empty array if years arguments is not defined
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

    def self.get_most_recent_hires
        offers = Offer.includes(application: [:candidate], job: [:department])
                    .where("custom_fields ->> 'employment_type' = ? AND
                            job_id != ? AND
                            status = ?", 'Full-time', FILTERED_JOB_ID, 'accepted').order(resolved_at: :desc).limit(3)
        
        hires_return_array = Array.new
        offers.each do |offer| 
            hire_hash = {id: offer.id} 
            hire_hash['hire_name'] = offer.application.candidate.first_name + ' ' + offer.application.candidate.last_name
            hire_hash['guild'] = offer.job.department.name
            hire_hash['job'] = offer.job.name
            hire_hash['hire_date'] = MONTH_NAMES[offer.resolved_at.month] + ' ' + offer.resolved_at.year.to_s
            hires_return_array << hire_hash
        end    
        return hires_return_array
    end

    def self.get_offer_acceptance_ratios_ordered_by_years_and_months(years)
        Offer.create_year_by_year_data_object(years, :get_offer_acceptance_ratios_for_year_ordered_by_months)
    end

    def self.get_accepted_offers_ordered_by_years_and_months(years)
        Offer.create_year_by_year_data_object(years, :get_accepted_offers_for_year_ordered_by_months)
    end
end
