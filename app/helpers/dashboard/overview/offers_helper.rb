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

    def get_months
        {
            Jan: 1, 
            Feb: 2, 
            Mar: 3, 
            Apr: 4, 
            May: 5, 
            Jun: 6, 
            Jul: 7, 
            Aug: 8, 
            Sep: 9,
            Oct: 10, 
            Nov: 11,
            Dec: 12
        }
    end
end
