class Dashboard::Guilds::TechnologyController < ApplicationController
    layout 'dashboard'
    set_tab :guilds

    def show
        @current_guild = 'Technology'
        @updating = UiHelper.find_by(name: 'Departments').updating
        render 'dashboard/guilds/individual-guild'
    end
end
