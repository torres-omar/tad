class ExternalSource::Offers::UpdateOffer 
    include Callable

    def initialize(offer, params)
        @offer = offer
        @offer_params = params
    end

    def call
        incoming_offer_status =  @offer_params['offer_status'].downcase
        current_status = @offer.status
        @offer.update(@offer_params.slice(*Offer.column_names))
        @offer.status = @offer_params['offer_status'] == 'Created' ? 'unresolved' : incoming_offer_status
        @offer.starts_at = @offer_params['start_date']
        @offer.custom_fields['employment_type'] = @offer_params['custom_fields']['employment_type']['value']
        @offer.save

        if (incoming_offer_status == 'accepted' || incoming_offer_status == 'rejected') and incoming_offer_status != current_status
            client_data = {
                message: 'An offer was accepted!',
                accepted: true, 
                accepted_year: @offer.resolved_at.year,
                accepted_month: @offer.resolved_at.month, 
                created_year: @offer.created_at.year, 
                created_month: @offer.created_at.month 
            }
            if incoming_offer_status == 'accepted'
                Pusher.trigger('private-tad-channel', 'offer-accepted', client_data)
            elsif incoming_offer_status == 'rejected'
                client_data[:accepted] = false
                client_data[:message] = 'An offer was rejected!'
                Pusher.trigger('private-tad-channel', 'offer-rejected', client_data)
            end 
        end
    end
end
