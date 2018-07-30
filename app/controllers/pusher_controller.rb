class PusherController < ApplicationController
    
    def auth 
        if admin_signed_in?
            response = Pusher.authenticate(params[:channel_name], params[:socket_id], {
                user_id: current_admin.id
            })
            render json: response
        else
            render text: 'Forbidden', status: '403'
        end
    end
end
