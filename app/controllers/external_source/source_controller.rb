class ExternalSource::SourceController < ApplicationController
    protect_from_forgery with: :null_session
    skip_before_action :authenticate_admin!
    before_action :authenticate, :check_if_ping_action

    def authenticate
        if request.headers['Signature']
            request_signature = request.headers['Signature'].split[1]
            digest = OpenSSL::Digest.new('sha256')
            signature = OpenSSL::HMAC.hexdigest(digest, '$plated_utopia#', request.body.read)
            @authenticated = request_signature == signature ? true : false
            unless @authenticated
                render json: {authentication_failed: 'unable to process request'}, status: 401
            end
        else
            render json: {error: 'a signature must be provided'}, status: 400
        end
    end

    def check_if_ping_action
        # used when web hook is created in greenhouse. Works as a test.
        render json: {success: 'Pinged'} if request.request_parameters['action'] == 'ping'
    end
end
