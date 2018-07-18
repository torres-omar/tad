module Dashboard::Overview::OffersHelper
    def get_offer_acceptance_ratio_gauge_year_month
        current_date = Time.now()
        Offer.get_offer_acceptance_ratio_for_month_in_year(current_date.year, current_date.month)
    end
end
