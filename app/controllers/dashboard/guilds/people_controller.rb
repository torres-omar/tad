class Dashboard::Guilds::PeopleController < ApplicationController
    layout 'dashboard'
    set_tab :guilds

    def show
        @current_guild = 'People'
        render 'dashboard/guilds/individual-guild'
    end    
end
