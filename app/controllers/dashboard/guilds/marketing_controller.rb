class Dashboard::Guilds::MarketingController < ApplicationController
    layout 'dashboard'
    set_tab :guilds

    def show
        @current_guild = 'Marketing'
        render 'dashboard/guilds/individual-guild'
    end
end
