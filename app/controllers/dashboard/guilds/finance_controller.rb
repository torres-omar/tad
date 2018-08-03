class Dashboard::Guilds::FinanceController < ApplicationController
    layout 'dashboard'
    set_tab :guilds

    def show
        @current_guild = 'Finance'
        render 'dashboard/guilds/individual-guild'
    end
end
