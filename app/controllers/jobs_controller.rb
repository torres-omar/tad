class JobsController < ApplicationController
    protect_from_forgery with: :null_session
    skip_before_action :authenticate_admin!

    def create
        Pusher.trigger('private-my-channel', 'my-event', {
            message: 'hello world'
        })
        render json: {success: "success!"}
    end

end
