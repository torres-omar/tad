class Offer < ApplicationRecord

    belongs_to :application, 
        class_name: 'Application', 
        foreign_key: :application_id

    belongs_to :job, 
        class_name: 'Job', 
        foreign_key: :job_id

    # note: promotions, interns. Are we counting them?

    def self.get_accepted_offers_for_year_and_month(year, month)
        Offer.where("extract(year from resolved_at) = ? AND
                     extract(month from resolved_at) = ? AND
                     status = ? AND 
                     custom_fields ->> 'employment_type' = ? AND
                     job_id != ?", year, month, 'accepted', 'Full-time', 571948)
    end

    def self.get_accepted_offers_for_year(year)
        Offer.where("extract(year from resolved_at) = ? AND 
                     status = ? AND 
                     custom_fields ->> 'employment_type' = ? AND
                     job_id != ?", year, 'accepted', 'Full-time', 571948)
    end

    def self.get_accepted_offers_ordered_by_year_and_month(years)
        # initialize empty array to store year by year data
        yearly_data = Array.new
        # initialize years to empty array if years arguments is not defined
        years = [] unless years
        # make data hash for each year passed in as parameter
        years.each{|year| yearly_data << {name: Integer(year)}}
        # for each year, fetch respective data
        yearly_data.each do |data| 
            year = data[:name]
            monthly_data = Offer.get_accepted_offers_for_year(year)
                                .group_by_month(:resolved_at).count.map{|k,v| [k.month, v]}.to_h
            # add data key to data hash
            data[:data] = Hash.new
            # add data for missing months
            current_date = DateTime.now
            (1..12).each do |month|
                if monthly_data.key?(month)
                    data[:data][@@month_names[month]] = monthly_data[month]
                else
                    unless month > current_date.month and year == current_date.year
                        data[:data][@@month_names[month]] = 0
                    end
                end
            end 
        end
    end
end