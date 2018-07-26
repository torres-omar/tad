class Charts::Overview::HiresController < ApplicationController
    def new_hires_per_year_and_month
        @offers = Offer.get_accepted_offers_ordered_by_years_and_months(params[:years])
        render json: @offers.chart_json, status: 200
    end

    def new_hires_per_year 
        @offers = Offer.get_accepted_offers_ordered_by_years(params[:years])
        render json: @offers.chart_json, status: 200
    end

    def hires_statistics_for_year
        @statistics_data = Offer.get_hires_statistics_data_for_year(params[:year].to_i)
        render 'charts/overview/hires/hires_statistics_for_year', status: 200
    end
end
