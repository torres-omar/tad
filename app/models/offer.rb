class Offer < ApplicationRecord

    belongs_to :application, 
        class_name: 'Application', 
        foreign_key: :application_id

    belongs_to :job, 
        class_name: 'Job', 
        foreign_key: :job_id

 

        
    # note: promotions, interns. Are we counting them?

    def self.get_accepted_offers_by_year_and_month(year, month)
        Offer.where("extract(year from resolved_at) = ? AND
                     extract(month from resolved_at) = ? AND
                     status = ? AND 
                     custom_fields ->> 'employment_type' = ? AND
                     job_id != ?", year, month, 'accepted', 'Full-time', 571948)
    end

    def self.get_accepted_offers_by_year(year)
        Offer.where("extract(year from resolved_at) = ? AND 
                     status = ? AND 
                     custom_fields ->> 'employment_type' = ? AND
                     job_id != ?", year, 'accepted', 'Full-time', 571948)
    end

    def self.get_accepted_offers_ordered_by_year_and_month
        months = {
            1 => "Jan", 
            2 => "Feb", 
            3 => "Mar", 
            4 => "Apr", 
            5 => "May", 
            6 => "Jun", 
            7 => "Jul", 
            8 => "Aug", 
            9 => "Sep", 
            10 => "Oct", 
            11 => "Nov", 
            12 => "Dec"
        }
        # initialize empty hash to store year by year data
        years = Hash.new
        data = {}
        # count the number of years for which there is data available
        Offer.group_by_year(:resolved_at).count.each{|k,v| years[k.year] = nil}
        # for each year, fetch respective data
        years.each do |year,v| 
            yearly_data = Offer.get_accepted_offers_by_year(year).group_by_month(:resolved_at).count
            first_data_month = nil
            first_data_month = yearly_data.first[0].month unless yearly_data.first[0].month == 1
            if first_data_month 
                (1...(12 - first_data_month)).each{|month| data[[year, months[month]]] = 0 unless data[[year, months[month]]]}
            end
            yearly_data.each do |k, v| 
                data[[year, months[k.month]]] = v
            end
        end
        return data
    end
end
