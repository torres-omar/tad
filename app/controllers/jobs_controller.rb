class JobsController < ApplicationController
    skip_before_action :authenticate_admin!
    protect_from_forgery with: :null_session

    def create
        debugger
        render json: {success: "success!"}
    end

end
