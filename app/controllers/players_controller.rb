class PlayersController < ApplicationController

    def index
        @player = Player.first
    end
end
