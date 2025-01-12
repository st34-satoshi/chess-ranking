class PlayersComparisonsController < ApplicationController
  def index
    @players_comparison = PlayersComparison.first
  end

  def show
  end
end
