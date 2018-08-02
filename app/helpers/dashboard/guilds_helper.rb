module Dashboard::GuildsHelper
    def render_hires_by_guild_for_year(args = {})
        year = args[:year]
        if args[:current]
            year = Time.now().year 
        end
        options = {
                download: true,
                height: '30rem',
                id: "hires-by-guild-graph"
        }
        pie_chart charts_guilds_hires_by_guild_for_year_path(year: year), options
    end
end
