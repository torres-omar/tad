class ExternalSource::OffersController < ExternalSource::SourceController
    def create 
        offer_params = JSON.parse(request.body.read)['payload']['offer']
        offer = Offer.find_by(id: offer_params['id'])
        if offer 
            render json: {unsuccesful: 'Record already exists'}, status: 400
        else 
            ExternalSource::Offers::CreateOffer.call(offer_params, source_credentials)
            render json: {success: 'Web hook registered'}
        end
    end

    def update 
        offer_params = JSON.parse(request.body.read)['payload']['offer']
        offer = Offer.find_by(id: offer_params['id'])
        if offer 
            ExternalSource::Offers::UpdateOffer.call(offer, offer_params)
            render json: {success: 'Web hook registered'}
        else 
            ExternalSource::Offers::CreateOffer.call(offer_params, source_credentials)
            render json: {success: 'Web hook registered'}
        end
    end

    def delete
        offer = Offer.find_by(id: JSON.parse(request.body.read)['payload']['offer']['id'])
        if offer
            offer.destroy
            render json: {success: 'Offer deleted'}, status: 200
        else 
            render json: {unsuccesful: 'No record found'}, status: 404 
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
