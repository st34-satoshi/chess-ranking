class PlayersController < ApplicationController

    def index
        @players = Player.all.order(rating_standard: "DESC").page(params[:page]).per(25)
    end
end
