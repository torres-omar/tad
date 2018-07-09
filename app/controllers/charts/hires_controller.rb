class Charts::HiresController < ApplicationController
    def new_hires_per_year_and_month
        @offers = Offer.get_accepted_offers_ordered_by_year_and_month
        render json: @offers.chart_json
    end
end
