# frozen_string_literal: true

class PlayersController < ApplicationController
  def root
    redirect_to players_path
  end

  def index
    @search_parameter = search_params
    @records = Record.filtered_records(@search_parameter).ordered.page(params[:page]).per(50)
    last_month = @search_parameter.month.last_month
    player_ids = @records.map(&:player_id)
    @last_month_records = Record.in_order_of(:player_id, player_ids).year_is(last_month.year).month_is(last_month.month)
  end

  def index_json
    render json: Player.all.to_json(only: %i[ncs_id name_en])
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
    if @player.nil?
      new_uid = Redirect.new_player_public_uid(params[:id])
      if new_uid.nil?
        flash[:alert] = "Player not found" # TODO: 表示する
        redirect_to players_path
      else
        redirect_to player_path(new_uid), status: :moved_permanently
      end
    end
  end
end
