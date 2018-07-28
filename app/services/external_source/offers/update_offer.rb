class ExternalSource::Offers::UpdateOffer 
    include Callable

    def initialize(offer, params)
        @offer = offer
        @offer_params = params
    end

    def call 
        @offer.update(@offer_params.slice(*Offer.column_names))
        @offer.status = @offer_params['offer_status'] == 'Created' ? 'unresolved' : @offer_params['offer_status'].downcase
        @offer.starts_at = @offer_params['start_date']
        @offer.custom_fields['employment_type'] = @offer_params['custom_fields']['employment_type']['value']
        @offer.save
        # notify if offer has been accepted or rejected
        # TASK:
        # send accepted date and created date
        # used on client side to conditionally show graph updating based on 
        # current graph settings in control component
        if @offer.status == 'accepted'
            Pusher.trigger('private-tad-channel', 'offer-resolved', {
                message: 'An offer was accepted!',
                accepted: true, 
                rejected: false
            })
        elsif @offer.status == 'rejected'
            Pusher.trigger('private-tad-channel', 'offer-resolved', {
                message: 'An offer was rejected!',
                accepted: false, 
                rejected: true
            })
        end
    end
end
