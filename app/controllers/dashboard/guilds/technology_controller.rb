class Dashboard::Guilds::TechnologyController < ApplicationController
    layout 'dashboard'
    set_tab :guilds

    def show
        @current_guild = 'Technology'
        render 'dashboard/guilds/individual-guild'
    end
end
