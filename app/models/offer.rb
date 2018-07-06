class Offer < ApplicationRecord

    belongs_to :application, 
        class_name: 'Application', 
        foreign_key: :application_id

    belongs_to :job, 
        class_name: 'Job', 
        foreign_key: :job_id

        
    # note: promotions, interns. Are we counting them?

=begin
    Function: self.get_accepted_offers
    Returns: all full-time offers that were accepted for a given month within a year. 
    note -- does not count conversions (eg. CX Associate Temp to Full-time)
    Year (param): integer
    Moth (param): integer
=end
    def self.get_accepted_offers(year, month)
        offers = Offer.where("extract(year from resolved_at) = ? AND extract(month from resolved_at) = ? AND status = ?", year, month, "accepted")
        offers.select do |offer| 
            offer.custom_fields['employment_type'] == "Full-time" and offer.job_id != 571948
        end 
    end
end