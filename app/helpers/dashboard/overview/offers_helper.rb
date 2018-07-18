module Dashboard::Overview::OffersHelper
    def offer_acceptance_ratio_data_for_month_in_year(args = {})
        year = nil
        month = nil
        if args[:current]
            current_date = Time.now()
            year = current_date.year
            month = current_date.month 
        else
            year = args[:year]
            month = args[:month]
        end 
        Offer.get_offer_acceptance_ratio_data_for_month_in_year(year, month)
    end
end
