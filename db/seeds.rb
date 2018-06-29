# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Admin.destroy_all
Application.destroy_all
Admin.create(email: ENV['admin_email'], password: ENV['admin_password'])
api_token = ENV['greenhouse_harvest_key']
credentials = Base64.strict_encode64(api_token + ':')
applications_response = Typhoeus::Request.new(
            'https://harvest.greenhouse.io/v1/applications', 
            method: :get, 
            headers: {"Authorization": "Basic " + credentials},
            params: {per_page: 10}
).run

applications = JSON.parse(applications_response.body)
applications.each do |application| 
    Application.create(application)
end 







