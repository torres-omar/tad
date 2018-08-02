class GreenhouseController < ApplicationController
    protect_from_forgery with: :null_session
    skip_before_action :authenticate_admin!
    # before_action :authenticate

    def authenticate
        @authenticated = false
        if request.headers['Signature']
            request_signature = request.headers['Signature'].split[1]
            digest = OpenSSL::Digest.new('sha256')
            signature = OpenSSL::HMAC.hexdigest(digest, '$plated_utopia#', request.body.read)
            @authenticated = true if request_signature == signature
        end
    end

    def authenticated?
        @authenticated
    end
end
