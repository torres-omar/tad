class JobsController < ApplicationController
    protect_from_forgery with: :null_session
    skip_before_action :authenticate_admin!

    def create
        Pusher.trigger('private-my-channel', 'my-event', {
            message: 'hello world'
        })
        render json: {success: "success!"}
    end

    def stages
        response = Typhoeus::Request.new(
            'https://harvest.greenhouse.io/v1/job_stages', 
            {
                method: :get, 
                headers: {"Authorization": 'Basic ' + harvest_credentials },
                params: {per_page: 500}
            }
        ).run
        render json: JSON.parse(response.body)
    end



end
