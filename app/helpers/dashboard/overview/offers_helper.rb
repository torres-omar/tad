module Dashboard::Overview::OffersHelper
    def offer_acceptance_ratio_data_for_month_in_year(args = {})
        return @response_month_year if @response_month_year
        year = args[:year]
        month = args[:month]
        if args[:current]
            current_date = Time.now()
            year = current_date.year
            month = current_date.month 
        end 
        @response_month_year = Offer.get_offer_acceptance_ratio_data_for_month_in_year(year, month)
        return @response_month_year
    end

    def get_months
        {
            Jan: 1, 
            Feb: 2, 
            Mar: 3, 
            Apr: 4, 
            May: 5, 
            Jun: 6, 
            Jul: 7, 
            Aug: 8, 
            Sep: 9,
            Oct: 10, 
            Nov: 11,
            Dec: 12
        }
    end

    def offer_acceptance_ratio_data_for_year(args = {})
        return @response_year if @response_year
        year = args[:year]
        if args[:current]
            year = Time.now().year
        end
        @response_year = Offer.get_offer_acceptance_ratio_data_for_year(year)
        return @response_year
    end

    def render_offer_acceptance_ratios(years)
        years ||= get_years
        options = {
            curve: false, 
            download: true, 
            xtitle: 'Month', 
            ytitle: 'Ratio',
            height: "20rem",
            id: "offer-acceptance-ratios-graph"
        }
        area_chart charts_overview_offer_acceptance_ratios_path(years: years), options
    end

    def get_years
        Offer.group_by_year(:resolved_at).count.map{ |k,v| k.year }
    end
end
