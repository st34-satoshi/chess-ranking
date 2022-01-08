# frozen_string_literal: true

class PlayersController < ApplicationController
  def root
    redirect_to players_path
  end

  def index
    @search_parameter = search_params
    @players = Player.filtered_players(@search_parameter).ordered.page(params[:page]).per(25)
  end

  private

  def search_params
    PlayerSearchParameter.new(params.fetch(:player_search_parameter, {}))
  end
end
