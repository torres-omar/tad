class Resources::UpdateAllJobs
    include Callable

    # #### This service updates the cache by making new calls to the Greenhouse API for the most up to date information.
    # #### Once the cache is updated, it broadcasts an event via pusher to all subscribers.  

    def initialize
        # initialize @hydra
        @hydra = Typhoeus::Hydra.hydra 
    end 

    def call 
        # update ui helper
        ui_helper = UiHelper.find_by(name: 'Departments')
        ui_helper.update(updating: true)
        
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

        # update ui helper
        UiHelper.find_by(name: 'Departments').update(last_updated: Time.now, updating: false)
        # broadcast event with pusher
        Pusher.trigger('private-tad-channel', 'department-update-complete', {
            message: 'DB updated. Ready for graph updates.'
        })
    end

    def response_callback(response, hydra, basic_request_options, resource, items_per_response)
        if response.body.length > 0  
            body = JSON.parse(response.body)
            if resource == 'Job'
                body.each do |e| 
                    job = Job.find_by(id: e['id'])
                    # if a job exists, update it. Most likely will be updated with new job openings data
                    if job
                        job.update(e)
                    else
                        # if the job doesn't exist, create it and add department id
                        job = resource.constantize.create(e)
                        job.department_id = job['departments'][0]['id']
                        job.save 
                    end
                    
                    # extract job openings from job
                    job.openings.each do |opening| 
                        opening_obj = JobOpening.find_by(id: opening['id']) 
                        # if job opening exists, update it. Most likely with status and closed date info
                        if opening_obj
                            opening_obj.update(opening)
                        else 
                            # if the opening doesn't exist, create it and add job id
                            opening_obj = JobOpening.create(opening)
                            opening_obj.job_id = job.id 
                            opening_obj.save
                        end
                    end
                end
            elsif resource == 'JobPost'
                body.each do |e| 
                    post = JobPost.find_by(id: e['id'])
                    # if the job post exists, update it. Most likely with status info
                    if post
                        post.update(e)
                    else
                        resource.constantize.create(e)
                    end
                end
            end
            # if likely that there are more items to fetch, build new request
            if body.length == items_per_response
                build_new_request(response, @hydra, basic_request_options, resource, items_per_response) 
            end
        end
    end

    def build_new_request(response, hydra, basic_request_options, resource, items_per_response)
        # extract and parse header links
        if response.headers['link']
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
end
