# frozen_string_literal: true

class PlayersController < ApplicationController
  def root
    redirect_to players_path
  end

  def index
    @search_parameter = search_params
    @records = Record.filtered_records(@search_parameter).ordered.page(params[:page]).per(50)
    last_month = @search_parameter.month.last_month
    player_ids = @records.map{|r| r.player_id}
    @last_month_records = Record.in_order_of(:player_id, player_ids).year_is(last_month.year).month_is(last_month.month)
  end

  def index_json
    render json: Player.all.to_json(only: [:ncs_id, :name_en])
  end

  def show
    set_player
  end

  private

  def search_params
    PlayerSearchParameter.new(params.fetch(:player_search_parameter, {}))
  end

  def set_player
    @player = Player.find_by(public_uid: params[:id])
  end
end
