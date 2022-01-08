# frozen_string_literal: true

class PlayersController < ApplicationController
  def root
    redirect_to players_path
  end

  # rubocop:disable Metrics/AbcSize Metrics/MethodLength
  def index
    @search_parameter = search_params
    @players = Player.filtered_players(@search_parameter).ordered.page(params[:page]).per(25)
  end
  # rubocop:enable Metrics/AbcSize

  private

  def search_params
    PlayerSearchParameter.new(params[:player_search_parameter])
  end
end
