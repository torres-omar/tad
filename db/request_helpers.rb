module RequestHelpers
    def RequestHelpers.concerned_app_ids
        @concerned_app_ids
    end

    def RequestHelpers.concerned_app_ids=(val)
        @concerned_app_ids = val
    end

    def RequestHelpers.concerned_candidate_ids
        @concerned_candidate_ids
    end

    def RequestHelpers.concerned_candidate_ids=(val)
        @concerned_candidate_ids = val
    end

    def RequestHelpers.response_callback(response, hydra, basic_request_options, resource, items_per_response)
        if response.body.length > 0 
            body = JSON.parse(response.body)
            # create new resource instances 
            if resource == 'Offer'
                body.each do |e|
                    offer = resource.constantize.create(e)
                    @concerned_app_ids[offer.application_id] = offer.application_id
                end
            elsif resource == 'Application'
                body.each do |e| 
                    if @concerned_app_ids.key?(e['id'])
                        application = resource.constantize.create(e)
                        @concerned_candidate_ids[application.candidate_id] = application.candidate_id
                    end
                end
            elsif resource == 'Candidate'
                body.each do |e|
                    if @concerned_candidate_ids.key?(e['id'])
                        resource.constantize.create(e)
                    end
                end
            else
                body.each{ |e| resource.constantize.create(e) }
            end

            # if likely that there are more items to fetch, build new request
            if body.length == items_per_response
                build_new_request(response, hydra, basic_request_options, resource, items_per_response) 
            end
        end
    end

    def RequestHelpers.build_new_request(response, hydra, basic_request_options, resource, items_per_response)
        if response.headers['link']
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

end
