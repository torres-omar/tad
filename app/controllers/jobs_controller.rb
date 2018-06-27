class JobsController < ApplicationController
    def index
        response = Typhoeus::Request.new(
            'https://harvest.greenhouse.io/v1/jobs', 
            method: :get, 
            headers: {"Authorization": "Basic " + harvest_credentials}
        ).run
        @jobs = JSON.parse(response.body)
        respond_to do |format|
            format.html
            format.json {render 'api/jobs/index.json.jbuilder'}
        end
    end
end
