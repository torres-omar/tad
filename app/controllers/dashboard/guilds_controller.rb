class Dashboard::GuildsController < ApplicationController
    layout 'dashboard'
    set_tab :guilds

    def index 
    end

    def update_guilds
        # if Time.now() >= (Department.first.last_updated + 30*60)
            Resources::UpdateAllJobs.call
            render json: {updated: 'Success'}, status: 200
        # else
            # render json: {cannot_update: 'Too early to update'}, status: 400
        # end
    end
end
