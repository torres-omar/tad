class Charts::HiresController < ApplicationController
    before_action :fetch_data

    def new_hires_per_year_and_month
        render json: @offers.chart_json
    end

    def change_graph_settings
        @years = params[:years]
        @graph_type = params[:graph_type]
        respond_to do |format| 
            format.js
        end
    end

    def fetch_data 
        @offers = Offer.get_accepted_offers_ordered_by_year_and_month(params[:years])
    end
end
