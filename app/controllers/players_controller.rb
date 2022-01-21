# frozen_string_literal: true

class PlayersController < ApplicationController
  def root
    redirect_to players_path
  end

  def index
    @search_parameter = search_params
    @records = Record.filtered_records(@search_parameter).ordered.page(params[:page]).per(25)
  end

  def show
  end

  private

  def search_params
    PlayerSearchParameter.new(params.fetch(:player_search_parameter, {}))
  end
end
