module Overview::HiresHelper
    def render_hires_years_months(graph_type, years)
        graph_type ||= "line"
        years ||= get_years
        options = {
                download: true,
                height: "24rem",
                ytitle: "Hires",
                xtitle: "Month",
                id: "years-months-hires",
                curve: false
        }
        if graph_type == "line"
            line_chart charts_new_hires_years_months_path(years: years), options
        elsif graph_type == "column" 
            options[:stacked] = true
            column_chart charts_new_hires_years_months_path(years: years), options
        end 
    end

    def get_years
        Offer.group_by_year(:resolved_at).count.map{ |k,v| k.year }
    end
end
