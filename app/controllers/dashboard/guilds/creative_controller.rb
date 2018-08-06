class Dashboard::Guilds::CreativeController < ApplicationController
    layout 'dashboard'
    set_tab :guilds

    def show
        @current_guild = 'Creative'
        render 'dashboard/guilds/individual-guild'
    end
end
