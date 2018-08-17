class Charts::Overview::HiresController < ApplicationController
    def new_hires_per_year_and_month
        hires = Offer.get_accepted_offers_ordered_by_years_and_months(params[:years])
        render json: hires.chart_json, status: 200
    end

    def new_hires_per_year 
        hires = Offer.get_accepted_offers_ordered_by_years(params[:years])
        render json: hires.chart_json, status: 200
    end

    def hires_statistics_for_year
        statistics_data = Offer.get_hires_statistics_data_for_year(params[:year].to_i)
        render json: statistics_data, status: 200
    end

    def most_recent_hire
        recent_hire = Offer.get_most_recent_hires[0]
        render json: recent_hire, status: 200
    end
end
