class ChartsController < ApplicationController
    def new_hires_per_year_and_month
        # @offers = {[2017, 'Jan'] => 0, [2017, 'Feb'] => 4, [2018, 'Jan'] => 5, [2018, 'Feb'] => 9}
        @offers = Offer.get_accepted_offers_ordered_by_year_and_month
        render json: @offers.chart_json
    end
end
