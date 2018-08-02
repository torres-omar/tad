class Charts::Guilds::HiresController < ApplicationController
    def hires_by_guild_for_year
        hires = Offer.get_hires_by_guild_for_year(params[:year])
        render json: hires, status: 200
    end
end
