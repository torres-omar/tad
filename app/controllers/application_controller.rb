class ApplicationController < ActionController::Base

    def harvest_credentials
        return @credentials unless @credentials.nil?
        self.generate_harvest_credentials!
    end

    def generate_harvest_credentials!
        api_token = ENV['greenhouse_harvest_key']
        @credentials = Base64.strict_encode64(api_token + ':')
    end
end
