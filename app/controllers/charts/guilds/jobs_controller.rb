class Charts::Guilds::JobsController < ApplicationController
    def jobs_stats_for_guild
        data = Hash.new
        data[:live_jobs] = Department.get_live_jobs_for_department(params[:guild])
        data[:live_openings] = Department.get_live_jobs_for_department(params[:guild])
        render json: data, status: 200
    end
end
