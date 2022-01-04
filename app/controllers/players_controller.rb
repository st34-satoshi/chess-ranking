# frozen_string_literal: true

class PlayersController < ApplicationController
  def root
    redirect_to players_path
  end

  # rubocop:disable Metrics/AbcSize Metrics/MethodLength
  def index
    @players = Player.filtered_players(params).ordered.page(params[:page]).per(25)
    # TODO: create a Filter model
    @name = params[:name]
    @rating_lower = params[:rating_lower].to_i
    @rating_upper = if params[:rating_upper]
                      params[:rating_upper].to_i
                    else
                      3000
                    end
    @active = params[:active] || 'all'
  end
  # rubocop:enable Metrics/AbcSize
end
