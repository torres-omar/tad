class OffersController < GreenhouseController
    def create 
        if authenticated?
            # used when web hook is created in greenhouse. Works as a test.
            if request.request_parameters['action'] == 'ping'
                render json: {success: 'Pinged'}
            else 
                # when request is not a test
                offer_params = JSON.parse(request.body.read)['payload']['offer']
                new_offer = Offer.new(offer_params.slice(*Offer.column_names))
                new_offer.starts_at = offer_params['start_date']
                new_offer.status = offer_params['offer_status'] == 'Created' ? 'unresolved' : offer_params['offer_status']
                new_offer.custom_fields['employment_type'] = offer_params['custom_fields']['employment_type']['value']
                new_offer.save
                render json: {success: 'Web hook registered'}
            end
        else
            render json: {authentication_failed: 'unable to process request'}, status: 401 
        end
    end

    def update 
        if authenticated?
            if request.request_parameters['action'] == 'ping'
                render json: {success: 'Pinged'}
            else
                offer_params = JSON.parse(request.body.read)['payload']['offer']
                filtered_params = offer_params.slice(*Offer.column_names)
                offer = Offer.find_by(id: offer_params['id'])
                if offer 
                    offer.update(filtered_params)
                    offer.status = offer_params['offer_status']
                    offer.starts_at = offer_params['start_date']
                    offer.custom_fields['employment_type'] = offer_params['custom_fields']['employment_type']['value']
                    offer.save
                    render json: {success: 'Web hook registered'}
                else 
                    new_offer = Offer.new(filtered_params)
                    new_offer.starts_at = offer_params['start_date']
                    new_offer.status = offer_params['offer_status'] == 'Created' ? 'unresolved' : offer_params['offer_status']
                    new_offer.custom_fields['employment_type'] = offer_params['custom_fields']['employment_type']['value']
                    new_offer.save
                    render json: {success: 'Web hook registered'}
                end
            end
        else 
            render json: {authentication_failed: 'unable to process request'}, status: 401
        end
    end

    def test 
        response = Typhoeus::Request.new(
            'https://harvest.greenhouse.io/v1/offers/1201746', 
            {
                method: :get, 
                headers: {"Authorization": 'Basic ' + harvest_credentials },
                params: {per_page: 500}
            }
        ).run
        render json: JSON.parse(response.body)
    end 
end
