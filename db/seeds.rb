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

# applications array
applications = [] 

# candidates array
candidates = [] 

# build applications request
applications_request = Typhoeus::Request.new(
    'https://harvest.greenhouse.io/v1/applications',
    basic_get_request_options
)

applications_request.on_complete do |response| 
    RequestHelpers::response_callback(response, hydra, basic_get_request_options, applications, items_per_response)
end


hydra.queue applications_request
hydra.run 

debugger
applications.each do |application| 
    a = Application.new(application)
    if !a.save
        debugger
    end
end 







