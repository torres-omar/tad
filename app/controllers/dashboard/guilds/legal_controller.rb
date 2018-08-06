class Dashboard::Guilds::LegalController < ApplicationController
    layout 'dashboard'
    set_tab :guilds

    def show
        @current_guild = 'Legal'
        render 'dashboard/guilds/individual-guild'
    end
end
