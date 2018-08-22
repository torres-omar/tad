class TestController < ApplicationController
    protect_from_forgery with: :null_session
    skip_before_action :authenticate_admin!


    def test
        api_token = ENV['greenhouse_harvest_key']
        credentials = Base64.strict_encode64(api_token + ':')
        basic_get_request_options = {
            method: :get, 
            headers: {"Authorization": "Basic " + credentials},
            params: {per_page: 500}
        }

        response = Typhoeus::Request.new(
            'https://harvest.greenhouse.io/v1/candidates/46423836', 
            basic_get_request_options
        ).run 

        render json: JSON.parse(response.body)
    end
end
