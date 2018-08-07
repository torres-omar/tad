class ApplicationController < ActionController::Base
    before_action :authenticate_admin!
    protect_from_forgery with: :exception, prepend: true

    # send admins to dashboard upon successful sign in.
    # redirect user to previous url if present
    def after_sign_in_path_for(resource)
        stored_location_for(resource) || dashboard_overview_path
    end
end
