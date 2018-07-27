class ExternalSource::Offers::CreateOffer 
    include Callable

    def initialize(params) 
        @offer_params = params
        @new_offer = Offer.new(@offer_params.slice(*Offer.column_names))
    end

    def call
        @new_offer.starts_at = @offer_params['start_date']
        @new_offer.status = @offer_params['offer_status'] == 'Created' ? 'unresolved' : @offer_params['offer_status'].downcase
        @new_offer.custom_fields['employment_type'] = @offer_params['custom_fields']['employment_type']['value']
        @new_offer.save 
        Pusher.trigger('private-tad-channel', 'offer-created', {
            message: 'A new offer was created.'
        })
    end
end
