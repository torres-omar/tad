class OffersController < GreenhouseController
    def create 
        if authenticated?
            render json: {success: 'from offers'}
        else
            render json: {authentication_failed: 'unable to process request'}, status: 401 
        end
    end
end
