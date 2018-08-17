module ApplicationHelper
    def get_years
        return @years if @years
        @years = Offer.group_by_year(:resolved_at).count.map{ |k,v| k.year }
    end
end
