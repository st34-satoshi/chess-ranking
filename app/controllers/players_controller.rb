class PlayersController < ApplicationController

  def index
    @players = Player.filtered_players(params).ordered.page(params[:page]).per(25)
    # TODO: create a Filter model
    @name = params[:name]
    @rating_lower = params[:rating_lower].to_i
    if params[:rating_upper]
      @rating_upper = params[:rating_upper].to_i
    else
      @rating_upper = 3000
    end
  end

end
