module Dashboard::Overview::HiresHelper
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

    def get_years
        Offer.group_by_year(:resolved_at).count.map{ |k,v| k.year }
    end
end
