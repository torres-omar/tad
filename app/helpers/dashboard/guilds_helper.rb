module Dashboard::GuildsHelper
    def render_hires_by_guild_for_year(args = {})
        year = args[:year]
        if args[:current]
            year = Time.now().year 
        end
        options = {
                height: '30rem',
                id: "hires-by-guild-graph",
                donut: true
        }
        pie_chart charts_guilds_hires_by_guild_for_year_path(year: year), options
    end

    def render_hires_per_year_for_guild(guild)
        years = get_years
        options = {
            xtitle: 'Hires',
            ytitle: 'Year',
            label: 'Hires',
            download: true, 
            height: "20rem",
            id: "guild-hires-by-year"
        }
        bar_chart charts_guilds_hires_by_year_for_guild_path(guild: guild, years: years), options
    end

    def get_years
        Offer.group_by_year(:resolved_at).count.map{ |k,v| k.year }
    end

    def render_live_jobs_for_guild(guild)
        Department.get_live_jobs_for_department(guild).size
    end

    def render_live_openings_for_guild(guild)
        Department.get_live_openings_for_department(guild).size
    end

    def render_last_updated_date_for_guilds
        date = UiHelper.find_by(name: 'Departments').last_updated.localtime
        months = {
            1 => 'Jan', 
            2 => 'Feb', 
            3 => 'Mar', 
            4 => 'Apr', 
            5 => 'May', 
            6 => 'Jun', 
            7 => 'Jul', 
            8 => 'Aug', 
            9 => 'Sept',
            10 => 'Aug', 
            11 => 'Nov',
            12 => 'Dec'
        }

        "#{date.strftime("%I:%M %p")} #{months[date.month]} #{date.day}"
    end

    def render_updating_state
        UiHelper.find_by(name: 'Departments').updating
    end

    def percent_of_open_jobs_for_department_data(guild)
        return @jobs_percent_data if @jobs_percent_data
        @jobs_percent_data = Job.get_percent_of_open_jobs_for_department_data(guild)
    end

    def openings_filled_by_department(guild)
        Job.get_openings_filled_by_department(guild)
    end

    def render_hires_per_source_for_guild(guild)
        options = {
                height: '22rem',
                id: "hires-by-source-for-guild-graph",
                donut: true,
                legend: 'top'

        }
        pie_chart charts_guilds_hires_by_source_for_guild_path(guild: guild), options
    end
end
