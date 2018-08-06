module Dashboard::Guilds::TechnologyHelper
    def render_hires_per_year_for_guild(guild)
        years = get_years
        options = {
            xtitle: 'Hires',
            ytitle: 'Year',
            label: 'Hires',
            download: true, 
            height: "20rem",
            id: "guild_hires-by-year"
        }
        bar_chart charts_guilds_hires_by_year_for_guild_path(guild: guild, years: years), options
    end

    def get_years
        Offer.group_by_year(:resolved_at).count.map{ |k,v| k.year }
    end
end
