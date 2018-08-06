class Dashboard::Guilds::CustomerExperienceController < ApplicationController
    layout 'dashboard'
    set_tab :guilds

    def show
        @current_guild = 'Customer Experience'
        render 'dashboard/guilds/individual-guild'
    end
end
