class ExternalSource::OffersController < ExternalSource::SourceController
    def create 
        offer_params = JSON.parse(request.body.read)['payload']['offer']
        ExternalSource::Offers::CreateOffer.call(offer_params)
        render json: {success: 'Web hook registered'}
    end

    def update 
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

    def delete
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
