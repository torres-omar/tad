module Overview::HiresHelper
    def render_hires_years_months(graph_type, years)
        graph_type ||= "line"
        years ||= get_years
        if graph_type == "line"
            line_chart charts_new_hires_years_months_path(years: years), line_options
        elsif graph_type == "column" 
            column_chart charts_new_hires_years_months_path(years: years), column_options
        end 
    end

    def get_years
        Offer.group_by_year(:resolved_at).count.map{|k,v| k.year}
    end

    private
    
    def line_options 
        {
            download: true
        }
    end

    def column_options
        {
            download: true, 
            stacked: true
        }
    end
end
