class Offer < ApplicationRecord
    belongs_to :application, 
        class_name: 'Application', 
        foreign_key: :application_id,
        optional: true

    belongs_to :job, 
        class_name: 'Job', 
        foreign_key: :job_id, 
        optional: true

    def self.get_accepted_offers_for_month_in_year(year, month)
        Offer.where("extract(year from resolved_at) = ? AND
                     extract(month from resolved_at) = ? AND
                     status = ? AND 
                     custom_fields ->> 'employment_type' = ? AND
                     job_id != ?", year, month, 'accepted', 'Full-time', 571948)
    end

    def self.get_accepted_offers_for_year_ordered_by_months(year)
        offers = Offer.where("extract(year from resolved_at) = ? AND
                              status = ? AND
                              custom_fields ->> 'employment_type' = ? AND
                              job_id != ?", year, 'accepted', 'Full-time', 571948)
        offers.group_by_month(:resolved_at).count.map{ |k,v| [k.month, v] }.to_h
    end

    def self.get_accepted_offers_ordered_by_years(years)
        offers = Offer.where("extract(year from resolved_at) IN (?) AND
                              status = ? AND
                              custom_fields ->> 'employment_type' = ? AND
                              job_id != ?", years, 'accepted', 'Full-time', 571948)
        offers.group_by_year(:resolved_at).count.map{ |k,v| [k.year, v] }
    end

    def self.get_offer_acceptance_ratios_for_year_ordered_by_months(year)
        # get all offers for a year
        offers = Offer.where("extract(year from created_at) = ? AND
                              custom_fields ->> 'employment_type' = ? AND
                              job_id != ?", year, 'Full-time', 571948)
        # get all offers that were accepted for a given year
        accepted_offers = Offer.where("extract(year from created_at) = ? AND
                                       custom_fields ->> 'employment_type' = ? AND
                                       job_id != ? AND
                                       status = ?", year, 'Full-time', 571948, 'accepted')
        # group accepted offers by month and store in hash
        accepted_offers = accepted_offers.group_by_month(:created_at).count.map{ |k,v| [k.month, v] }.to_h
        # group offers by month and store in hash
        monthly_data = offers.group_by_month(:created_at).count.map{ |k,v| [k.month, v] }.to_h
        # calculate offer-acceptance ratio for each month
        monthly_data.each do |k, v|
            number_of_accepted_offers = accepted_offers[k] ? accepted_offers[k] : 0 
            ratio = number_of_accepted_offers / v.to_f
            monthly_data[k] = ratio.nan? ? 0.0 : ratio
        end
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

    def self.get_offer_acceptance_ratios_ordered_by_years_and_months(years)
        Offer.create_year_by_year_data_object(years, :get_offer_acceptance_ratios_for_year_ordered_by_months)
    end

    def self.get_accepted_offers_ordered_by_years_and_months(years)
        Offer.create_year_by_year_data_object(years, :get_accepted_offers_for_year_ordered_by_months)
    end
end
