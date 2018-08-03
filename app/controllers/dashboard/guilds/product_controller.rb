class Dashboard::Guilds::ProductController < ApplicationController
    layout 'dashboard'
    set_tab :guilds

    def show
        @current_guild = 'Product'
        render 'dashboard/guilds/individual-guild'
    end
end

