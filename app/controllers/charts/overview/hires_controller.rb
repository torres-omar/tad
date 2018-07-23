class Charts::Overview::HiresController < ApplicationController
    def new_hires_per_year_and_month
        @offers = Offer.get_accepted_offers_ordered_by_years_and_months(params[:years])
        render json: @offers.chart_json
    end

    def new_hires_per_year 
        @offers = Offer.get_accepted_offers_ordered_by_years(params[:years])
        render json: @offers.chart_json 
    end
end
