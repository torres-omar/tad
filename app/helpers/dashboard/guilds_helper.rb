module Dashboard::GuildsHelper
    def render_hires_by_guild_for_year(args = {})
        year = args[:year]
        if args[:current]
            year = Time.now().year 
        end
        options = {
                download: true,
                height: '30rem',
                id: "hires-by-guild-graph",
                donut: true
        }
        pie_chart charts_guilds_hires_by_guild_for_year_path(year: year), options
    end

    def render_live_jobs_for_guild(guild)
        Department.get_live_jobs_for_department(guild).size
    end

    def render_live_openings_for_guild(guild)
        Department.get_live_openings_for_department(guild).size
    end

    def render_last_updated_date_for_guild(guild)
        date = Department.find_by(name: guild).last_updated.localtime
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

        "last updated: #{date.strftime("%I:%M %p")} #{months[date.month]} #{date.day}"
    end
end
