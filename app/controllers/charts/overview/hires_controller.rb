class Charts::Overview::HiresController < ApplicationController
    def new_hires_per_year_and_month
        @offers = Offer.get_accepted_offers_ordered_by_years_and_months(params[:years])
        render json: @offers.chart_json
    end

    def change_years_months_graph_settings
        @years = params[:years]
        @graph_type = params[:graph_type]
        respond_to do |format| 
            format.js
        end
    end

    def new_hires_per_year 
        @offers = Offer.get_accepted_offers_ordered_by_years(params[:years])
        render json: @offers.chart_json 
    end

    def change_years_graph_settings
        @years = params[:years]
        respond_to do |format| 
            format.js
        end
    end

    def offer_acceptance_ratios
        @ratios = Offer.get_offer_acceptance_ratios_ordered_by_years_and_months(params[:years])
        render json: @ratios.chart_json
    end
end
