module Dashboard::Overview::HiresHelper
    # find a way to call get_years once
    # maybe make it a function within the hires controller and make it a callback
    # only 'getting' the years if @years is not already defined
    def render_hires_years_months(graph_type, years)
        graph_type ||= "line"
        years ||= get_years
        options = {
                download: true,
                ytitle: "Hires",
                xtitle: "Month",
                curve: false,
                id: "years-months-hires-graph"
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
        options = {
            xtitle: 'Hires',
            label: 'Hires',
            download: true, 
            height: "19rem",
            id: "years-hires-graph"
        }
        bar_chart charts_overview_new_hires_years_path(years: years), options
    end

    def hires_statistics(args = {})
        year = args[:year]
        if args[:current]
            current_date = Time.now()
            year = current_date.year
        end 
        Offer.get_hires_statistics_data_for_year(year)
    end

    def get_years
        Offer.group_by_year(:resolved_at).count.map{ |k,v| k.year }
    end
end
