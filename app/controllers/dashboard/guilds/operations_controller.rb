class Dashboard::Guilds::OperationsController < ApplicationController
    layout 'dashboard'
    set_tab :guilds

    def show
        @current_guild = 'Operations'
        render 'dashboard/guilds/individual-guild'
    end
end
