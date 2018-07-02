module RequestHelpers

    def RequestHelpers.response_callback(response, hydra, basic_request_options, resource, items_per_response)
        body = JSON.parse(response.body)
        resource.concat(body)

        # if likely that there are more items to fetch, build new request
        if body.length == items_per_response
            build_new_request(response, hydra, basic_request_options, resource, items_per_response) 
        end
    end

    def RequestHelpers.build_new_request(response, hydra, basic_request_options, resource, items_per_response)
        links = LinkHeader.parse(response.headers['link']).to_a
        request = Typhoeus::Request.new(
            links[0][0], 
            basic_request_options
        )
        request.on_complete do |response| 
            # build a new request with new url query next page
            response_callback(response, hydra, basic_request_options, resource, items_per_response)
        end

        hydra.queue request
    end

end