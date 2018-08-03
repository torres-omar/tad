class Dashboard::Guilds::DataScienceController < ApplicationController
    layout 'dashboard'
    set_tab :guilds

    def show
        @current_guild = 'Data Science'
        render 'dashboard/guilds/individual-guild'
    end
end
