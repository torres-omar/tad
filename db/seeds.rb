# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require './db/request_helpers'

Admin.destroy_all
Application.destroy_all
Candidate.destroy_all 
Department.destroy_all
Job.destroy_all
JobOpening.destroy_all
JobPost.destroy_all
Offer.destroy_all 
UiHelper.destroy_all


# create admin account 
Admin.create(email: ENV['admin_email'], password: ENV['admin_password'])
# create ui helper
UiHelper.create(name: 'Departments', last_updated: Time.now(), updating: false);
# initialize hydra
hydra = Typhoeus::Hydra.hydra 

# create harvest API credentials
api_token = ENV['greenhouse_harvest_key']
credentials = Base64.strict_encode64(api_token + ':')

# items per response (greenhouse only allows a max of 500)
items_per_response = 500

# build basic request options
basic_get_request_options = {
    method: :get, 
    headers: {"Authorization": "Basic " + credentials},
    params: {per_page: items_per_response}
}

# build offers request 
offers_request = Typhoeus::Request.new(
    'https://harvest.greenhouse.io/v1/offers', 
    basic_get_request_options
)

# build applications request
applications_request = Typhoeus::Request.new(
    'https://harvest.greenhouse.io/v1/applications',
    basic_get_request_options
)

# build candidates request
candidates_request = Typhoeus::Request.new(
    'https://harvest.greenhouse.io/v1/candidates', 
    basic_get_request_options
)

# build departments request
departments_request = Typhoeus::Request.new(
    'https://harvest.greenhouse.io/v1/departments', 
    basic_get_request_options
)

# build jobs request
jobs_request = Typhoeus::Request.new(
    'https://harvest.greenhouse.io/v1/jobs', 
    basic_get_request_options
)

RequestHelpers::concerned_app_ids = Hash.new
RequestHelpers::concerned_candidate_ids = Hash.new

# requests callbacks
offers_request.on_complete do |response|
    RequestHelpers::response_callback(response, hydra, basic_get_request_options, 'Offer', items_per_response)
    hydra.queue applications_request
end

applications_request.on_complete do |response| 
    RequestHelpers::response_callback(response, hydra, basic_get_request_options, 'Application', items_per_response)
    hydra.queue candidates_request
end

candidates_request.on_complete do |response|
    RequestHelpers::response_callback(response, hydra, basic_get_request_options, 'Candidate', items_per_response)
end

departments_request.on_complete do |response|
    RequestHelpers::response_callback(response, hydra, basic_get_request_options, 'Department', items_per_response)
end

jobs_request.on_complete do |response|
    RequestHelpers::response_callback(response, hydra, basic_get_request_options, 'Job', items_per_response)
end


hydra.queue offers_request
hydra.queue departments_request
hydra.queue jobs_request
hydra.run 

# add department_id to jobs
Job.all.each do |job|
    job.department_id = job['departments'][0]['id']
    job.save
end

# add job_id to offers
Offer.includes(:application).all.each do |offer| 
    offer.job_id = offer.application.jobs[0]['id']
    offer.save
end






