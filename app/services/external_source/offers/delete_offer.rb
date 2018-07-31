class ExternalSource::Offers::DeleteOffer 
    include Callable

    def initialize(offer)
        @offer = offer
    end

    def call
        client_data = {
            message: 'An offer was deleted',
            created_year: @offer.created_at.year, 
            created_month: @offer.created_at.month 
        }
        if @offer.version == 1
            Pusher.trigger('private-tad-channel', 'offer-deleted', client_data)
        end
        @offer.destroy
    end
end
