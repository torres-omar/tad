class Offer < ApplicationRecord

    def self.get_accepted_offers_by_year(year)
        Offer.where("extract(year from resolved_at) = ? AND status = ?", year, "accepted")
    end

    # gets all offers that are full-time and were accepted, for a given month within a year
    def self.get_accepted_offers(year, month)
        offers = Offer.where("extract(year from resolved_at) = ? AND extract(month from resolved_at) = ? AND status = ?", year, month, "accepted")
        offers.select do |offer| 
            offer.custom_fields['employment_type'] == "Full-time" 
        end 
    end
end
