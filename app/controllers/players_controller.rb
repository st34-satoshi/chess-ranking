class PlayersController < ApplicationController

  def index
    @players = Player.players_name_has(params[:name]).ordered.page(params[:page]).per(25)
  end
end
