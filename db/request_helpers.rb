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
                    # create offer and store application_id
                    offer = resource.constantize.create(e)
                    @concerned_app_ids[offer.application_id] = offer.application_id
                end
            elsif resource == 'Application'
                body.each do |e| 
                    if @concerned_app_ids.key?(e['id'])
                        # create the application and store candidate_id
                        application = resource.constantize.create(e)
                        @concerned_candidate_ids[application.candidate_id] = application.candidate_id
                    end
                end
            elsif resource == 'Candidate'
                body.each do |e|
                    if @concerned_candidate_ids.key?(e['id'])
                        # create candidate
                        resource.constantize.create(e)
                    end
                end
            else
                body.each{ |e| resource.constantize.create(e) }
            end


            # if likely that there are more items to fetch, check for header links
            if body.length == items_per_response
                # if there are header links build a new request, else build associated resources
                if response.headers['link']
                    build_new_request(response, hydra, basic_request_options, resource, items_per_response) 
                else 
                    build_associated_resources(response, hydra, basic_request_options, resource, items_per_response)
                end
            else
                build_associated_resources(response, hydra, basic_request_options, resource, items_per_response)
            end
        end
    end

    def RequestHelpers.build_associated_resources(response, hydra, basic_request_options, resource, items_per_response)
         if resource == 'Offer'
            # build applications request
            applications_request = Typhoeus::Request.new(
                'https://harvest.greenhouse.io/v1/applications',
                basic_request_options
            )

            applications_request.on_complete do |response| 
                response_callback(response, hydra, basic_request_options, 'Application', items_per_response)
            end

            hydra.queue applications_request
        elsif resource == 'Application'
            # build candidates request
            candidates_request = Typhoeus::Request.new(
                'https://harvest.greenhouse.io/v1/candidates', 
                basic_request_options
            )

            candidates_request.on_complete do |response|
                response_callback(response, hydra, basic_request_options, 'Candidate', items_per_response)
            end

            hydra.queue candidates_request
        end
    end

    def RequestHelpers.build_new_request(response, hydra, basic_request_options, resource, items_per_response)
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
