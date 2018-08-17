module Dashboard::OverviewHelper
    def render_hires_years_months(graph_type, years)
        graph_type ||= "line"
        years ||= get_years
        options = {
                download: false,
                ytitle: "Hires",
                xtitle: "Month",
                curve: false,
                height: '20rem',
                id: "years-months-hires-graph"
        }
        if graph_type == "line"
            line_chart charts_overview_hires_by_years_months_path(years: years), options
        elsif graph_type == "column" 
            options[:stacked] = true
            column_chart charts_overview_hires_by_years_months_path(years: years), options
        end 
    end

    def render_hires_ordered_by_years(years)
        years ||= get_years
        options = {
            xtitle: 'Hires',
            ytitle: 'Year',
            label: 'Hires',
            download: false, 
            height: "20rem",
            id: "years-hires-graph"
        }
        bar_chart charts_overview_hires_per_year_path(years: years), options
    end

    def hires_statistics(args = {})
        return @hires_statistics if @hires_statistics
        year = args[:year]
        if args[:current]
            current_date = Time.now()
            year = current_date.year
        end 
        @hires_statistics = Offer.get_hires_statistics_data_for_year(year)
        return @hires_statistics
    end

    def recent_hires 
        Offer.get_most_recent_hires
    end

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
            download: false, 
            xtitle: 'Month', 
            ytitle: 'Ratio',
            height: "20rem",
            id: "offer-acceptance-ratios-graph"
        }
        area_chart charts_overview_offer_acceptance_ratios_path(years: years), options
    end
end
