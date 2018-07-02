class JobsController < ApplicationController
    def index
        response = Typhoeus::Request.new(
            'https://harvest.greenhouse.io/v1/jobs', 
            method: :get, 
            headers: {"Authorization": "Basic " + harvest_credentials},
            params: {per_page: 10}
        ).run
        @jobs = JSON.parse(response.body)
    end
end

