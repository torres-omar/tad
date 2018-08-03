class Charts::Guilds::HiresController < ApplicationController
    def hires_by_guild_for_year
        hires = Offer.get_hires_by_guild_for_year(params[:year])
        render json: hires, status: 200
    end

    def hires_by_year_for_guild
        hires = Offer.get_hires_by_year_for_guild(params[:guild], params[:years])
        render json: hires, status: 200
    end
end
