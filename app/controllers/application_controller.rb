class ApplicationController < ActionController::Base
    before_action :authenticate_admin!
    protect_from_forgery with: :exception, prepend: true

    # send admins to dashboard upon successful sign in.
    # redirect user to previous url if present
    def after_sign_in_path_for(resource)
        stored_location_for(resource) || overview_hires_path
    end

    def harvest_credentials
        return @credentials unless @credentials.nil?
        self.generate_harvest_credentials!
    end

    def generate_harvest_credentials!
        api_token = ENV['greenhouse_harvest_key']
        @credentials = Base64.strict_encode64(api_token + ':')
    end
end
