class Resources::UpdateAllJobs
    include Callable

    def initialize
        # initialize @hydra
        @hydra = Typhoeus::Hydra.hydra 
    end 

    def call 
        # Job.destroy_all
        # JobOpening.destroy_all
        # JobPost.destroy_all
        
        # fetch all jobs
        api_token = ENV['greenhouse_harvest_key']
        credentials = Base64.strict_encode64(api_token + ':')
        per_page = 500
        basic_request = {
            method: :get,
            headers: {"Authorization": 'Basic ' + credentials},
            params: {per_page: per_page}
        }
        
        # make requests and add callbacks
        jobs_request = Typhoeus::Request.new(
            "https://harvest.greenhouse.io/v1/jobs",
            basic_request    
        )
            
        jobs_request.on_complete do |response| 
            response_callback(response, @hydra, basic_request, 'Job', per_page)
        end

        posts_request = Typhoeus::Request.new(
            "https://harvest.greenhouse.io/v1/job_posts",
            basic_request
        )

        posts_request.on_complete do |response|
            response_callback(response, @hydra, basic_request, 'JobPost', per_page)
        end 

        # queue first two requests
        @hydra.queue jobs_request 
        @hydra.queue posts_request
        @hydra.run

        Department.update_all(last_updated: Time.now())
    end

    def response_callback(response, hydra, basic_request_options, resource, items_per_response)
        body = JSON.parse(response.body)
        # create new resource instances 
        if resource == 'Job'
            body.each do |e| 
                # job = resource.constantize.create(e)
                job = Job.find_by(id: e['id'])
                if job
                    job.update(e)
                else
                    job = resource.constantize.create(e)
                    # add department id to job
                    job.department_id = job['departments'][0]['id']
                    job.save 
                end
                
                # extract job openings from job
                job.openings.each do |opening| 
                    # create job openings
                    opening_obj = JobOpening.find_by(id: opening['id']) 
                    if opening_obj
                        opening_obj.update(opening)
                    else 
                        opening_obj = JobOpening.create(opening)
                        opening_obj.job_id = job.id 
                        opening_obj.save
                    end
                end
            end
        elsif resource == 'JobPost'
            body.each do |e| 
                # job = resource.constantize.create(e)
                post = JobPost.find_by(id: e['id'])
                if post
                    post.update(e)
                else
                    resource.constantize.create(e)
                end
            end
        end
        # if likely that there are more items to fetch, build new request
        if body.length == items_per_response
            build_new_request(response, hydra, basic_request_options, resource, items_per_response) 
        end
    end

    def build_new_request(response, hydra, basic_request_options, resource, items_per_response)
        # extract and parse header links
        links = LinkHeader.parse(response.headers['link']).to_a
        # build request for the next 'page' of items for this particular resource. 
        request = Typhoeus::Request.new(
            links[0][0], 
            basic_request_options
        )
        request.on_complete do |response| 
            response_callback(response, hydra, basic_request_options, resource, items_per_response)
        end

        hydra.queue request
    end
end
