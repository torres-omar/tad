module Dashboard::Overview::HiresHelper
    # find a way to call get_years once
    # maybe make it a function within the hires controller and make it a callback
    # only 'getting' the years if @years is not already defined
    def render_hires_years_months(graph_type, years)
        graph_type ||= "line"
        years ||= get_years
        options = {
                download: true,
                height: "19rem",
                ytitle: "Hires",
                xtitle: "Month",
                id: "years-months-hires",
                curve: false
        }
        if graph_type == "line"
            line_chart charts_overview_new_hires_years_months_path(years: years), options
        elsif graph_type == "column" 
            options[:stacked] = true
            column_chart charts_overview_new_hires_years_months_path(years: years), options
        end 
    end

    def render_hires_ordered_by_years(years)
        years ||= get_years
        bar_chart charts_overview_new_hires_years_path(years: years), xtitle: 'Hires', label: 'Hires', download: true
    end

    def render_offer_acceptance_ratios(years)
        years ||= get_years
        options = {
            curve: false, 
            download: true, 
            xtitle: 'Month', 
            ytitle: 'Ratio'
        }
        area_chart charts_overview_offer_acceptance_ratios_path(years: years), options
    end

    def get_years
        Offer.group_by_year(:resolved_at).count.map{ |k,v| k.year }
    end
end
