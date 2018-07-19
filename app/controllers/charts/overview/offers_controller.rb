class Charts::Overview::OffersController < ApplicationController
    def change_year_month_ratio_settings
        year = params[:year]
        month = params[:month]
        @data = Offer.get_offer_acceptance_ratio_data_for_month_in_year(year, month)
        respond_to do |format|
            format.js
        end
    end
end
