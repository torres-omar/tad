# class Resources::UpdateDepartmentJobs
#     include Callable

#     def initialize(department)
#         @department = department
#     end

#     def call
#         Job.where('department_id = ?', @department.id).destroy_all
#         JobOpening.joins(:job).where('jobs.department_id = ?', @department.id).destroy_all
#         JobPost.joins(:job).where('jobs.department_id = ?', @department.id).destroy_all
#         # fetch all jobs
#         api_token = ENV['greenhouse_harvest_key']
#         credentials = Base64.strict_encode64(api_token + ':')
#         per_page = 500
#         basic_request = {
#             method: :get,
#             headers: {"Authorization": 'Basic ' + credentials},
#             params: {per_page: per_page}
#         }
        
#         # make requests and add callbacks
#         jobs_request = Typhoeus::Request.new(
#             "https://harvest.greenhouse.io/v1/jobs",
#             basic_request    
#         )
            
#         jobs_request.on_complete do |response| 
#             response_callback(response, @hydra, basic_request, 'Job', per_page)
#         end

#         posts_request = Typhoeus::Request.new(
#             "https://harvest.greenhouse.io/v1/job_posts",
#             basic_request
#         )

#         posts_request.on_complete do |response|
#             response_callback(response, @hydra, basic_request, 'JobPost', per_page)
#         end 

#         # queue first two requests
#         @hydra.queue jobs_request 
#         @hydra.queue posts_request
#         @hydra.run

#         Department.update_all(last_updated: Time.now())
#     end

#     def response_callback(response, hydra, basic_request_options, resource, items_per_response)
#         body = JSON.parse(response.body)
#         # create new resource instances 
#         if resource == 'Job'
#             body.each do |e| 
#                 job = resource.constantize.create(e)
#                 # add department id to job
#                 job.department_id = job['departments'][0]['id']
#                 job.save 
#                 # extract job openings from job
#                 job.openings.each do |opening| 
#                     # create job openings 
#                     opening_obj = JobOpening.create(opening)
#                     opening_obj.job_id = job.id 
#                     opening_obj.save
#                 end
#             end
#         else
#             body.each{ |e| resource.constantize.create(e) }
#         end
#         # if likely that there are more items to fetch, build new request
#         if body.length == items_per_response
#             build_new_request(response, hydra, basic_request_options, resource, items_per_response) 
#         end
#     end

#     def build_new_request(response, hydra, basic_request_options, resource, items_per_response)
#         # extract and parse header links
#         links = LinkHeader.parse(response.headers['link']).to_a
#         # build request for the next 'page' of items for this particular resource. 
#         request = Typhoeus::Request.new(
#             links[0][0], 
#             basic_request_options
#         )
#         request.on_complete do |response| 
#             response_callback(response, hydra, basic_request_options, resource, items_per_response)
#         end

#         hydra.queue request
#     end
# end
