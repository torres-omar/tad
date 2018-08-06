class Dashboard::Guilds::CulinaryController < ApplicationController
    layout 'dashboard'
    set_tab :guilds

    def show
        @current_guild = 'Culinary'
        render 'dashboard/guilds/individual-guild'
    end
end
