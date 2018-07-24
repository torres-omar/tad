class ExternalSource::Offers::UpdateOffer 
    include Callable

    def initialize(offer, params)
        @offer = offer
        @offer_params = params
    end

    def call 
        @offer.update(@offer_params.slice(*Offer.column_names))
        @offer.status = @offer_params['offer_status']
        @offer.starts_at = @offer_params['start_date']
        @offer.custom_fields['employment_type'] = @offer_params['custom_fields']['employment_type']['value']
        @offer.save
        Pusher.trigger('private-tad-channel', 'offer-created', {
            message: 'A new offer was created.'
        })
    end
end
