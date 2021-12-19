class PlayersController < ApplicationController

    def index
        @players = Player.page(params[:page]).per(3)
    end
end
