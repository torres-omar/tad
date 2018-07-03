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
Offer.destroy_all 

# create admin account 
Admin.create(email: ENV['admin_email'], password: ENV['admin_password'])
# initialize hydra
hydra = Typhoeus::Hydra.hydra 

# create harvest API credentials
api_token = ENV['greenhouse_harvest_key']
credentials = Base64.strict_encode64(api_token + ':')

# items per response
items_per_response = 500

# build basic request options
basic_get_request_options = {
    method: :get, 
    headers: {"Authorization": "Basic " + credentials},
    params: {per_page: items_per_response}
}

# applications store
applications = [] 

# candidates store
candidates = [] 

# departments store
departments = [] 

# jobs store
jobs = []

# offers store 
offers = []


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

# build offers request 
offers_request = Typhoeus::Request.new(
    'https://harvest.greenhouse.io/v1/offers', 
    basic_get_request_options
)

applications_request.on_complete do |response| 
    RequestHelpers::response_callback(response, hydra, basic_get_request_options, applications, items_per_response)
end

candidates_request.on_complete do |response|
    RequestHelpers::response_callback(response, hydra, basic_get_request_options, candidates, items_per_response)
end

departments_request.on_complete do |response|
    RequestHelpers::response_callback(response, hydra, basic_get_request_options, departments, items_per_response)
end

jobs_request.on_complete do |response|
    RequestHelpers::response_callback(response, hydra, basic_get_request_options, jobs, items_per_response)
end

offers_request.on_complete do |response|
    RequestHelpers::response_callback(response, hydra, basic_get_request_options, offers, items_per_response)
end


hydra.queue applications_request
hydra.queue candidates_request
hydra.queue departments_request
hydra.queue jobs_request
hydra.queue offers_request
hydra.run 

applications.each do |application| 
    Application.create(application)
end 

candidates.each do |candidate| 
    Candidate.create(candidate)
end

departments.each do |department|
    Department.create(department)
end

jobs.each do |job|
    Job.create(job)
end

Job.all.each do |job|
    job.department_id = job['departments'][0]['id']
    job.save
end

offers.each do |offer| 
    Offer.create(offer)
end






