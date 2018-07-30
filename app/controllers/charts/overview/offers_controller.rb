class Charts::Overview::OffersController < ApplicationController
    def month_year_offer_acceptance_ratio
        @data = Offer.get_offer_acceptance_ratio_data_for_month_in_year(params[:year].to_i, params[:month].to_i)
        render 'charts/overview/offers/month_year_offer_acceptance_ratio', status: 200
    end

    def year_offer_acceptance_ratio
        @yearly_data = Offer.get_offer_acceptance_ratio_data_for_year(params[:year].to_i)
        render 'charts/overview/offers/year_offer_acceptance_ratio', status: 200
    end

    def offer_acceptance_ratios
        @ratios = Offer.get_offer_acceptance_ratios_ordered_by_years_and_months(params[:years])
        render json: @ratios.chart_json, status: 200
    end
end
