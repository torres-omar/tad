class Charts::Overview::OffersController < ApplicationController
    def month_year_offer_acceptance_ratio
        @data = Offer.get_offer_acceptance_ratio_data_for_month_in_year(params[:year].to_i, params[:month].to_i)
        respond_to do |format|
            format.json
        end
    end

    def year_offer_acceptance_ratio
        @yearly_data = Offer.get_offer_acceptance_ratio_data_for_year(params[:year].to_i)
        respond_to do |format|
            format.json
        end
    end

    def offer_acceptance_ratios
        @ratios = Offer.get_offer_acceptance_ratios_ordered_by_years_and_months(params[:years])
        render json: @ratios.chart_json
    end
end
