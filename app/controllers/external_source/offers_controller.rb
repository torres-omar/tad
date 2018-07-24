class ExternalSource::OffersController < ExternalSource::SourceController
    def create 
        if authenticated?
            # used when web hook is created in greenhouse. Works as a test.
            if request.request_parameters['action'] == 'ping'
                render json: {success: 'Pinged'}
            else 
                # when request is not a test
                offer_params = JSON.parse(request.body.read)['payload']['offer']
                ExternalSource::Offers::CreateOffer.call(offer_params)
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
                offer = Offer.find_by(id: offer_params['id'])
                if offer 
                    ExternalSource::Offers::UpdateOffer.call(offer, offer_params)
                    render json: {success: 'Web hook registered'}
                else 
                    ExternalSource::Offers::CreateOffer.call(offer_params)
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
