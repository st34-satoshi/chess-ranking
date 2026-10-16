# frozen_string_literal: true

class PlayersController < ApplicationController
  def root
    redirect_to players_path
  end

  def rapid
    index
    render :index unless performed?
  end

  def index
    @search_parameter = search_params
    rapid_route = action_name == 'rapid'
    if @search_parameter.rapid? != rapid_route
      query = request.query_parameters.symbolize_keys
      target = @search_parameter.rapid? ? rapid_path(query) : players_path(query)
      return redirect_to(target)
    end

    @records = Record.filtered_records(@search_parameter)
                     .order(@search_parameter.rating_column => :desc, :id => :asc).page(params[:page]).per(50)
    last_month = @search_parameter.month.last_month
    player_ids = @records.map(&:player_id)
    @last_month_records = Record.in_order_of(:player_id, player_ids).year_is(last_month.year).month_is(last_month.month)
    return unless @search_parameter.name.present?

    @non_membership_records = Record.non_membership_records(@search_parameter, player_ids,
                                                            @records.size)
  end

  def index_json
    render json: Player.all.to_json(only: %i[ncs_id name_en])
  end

  def show
    set_player
  end

  private

  def search_params
    search = params.fetch(:player_search_parameter, ActionController::Parameters.new)
    PlayerSearchParameter.new(search.reverse_merge(rating_type: action_name == 'rapid' ? 'rapid' : 'standard'))
  end

  def set_player
    @player = Player.find_by(public_uid: params[:id])
    return unless @player.nil?

    new_uid = Redirect.new_player_public_uid(params[:id])
    if new_uid.nil?
      flash[:alert] = 'Player not found' # TODO: 表示する
      redirect_to players_path
    else
      redirect_to player_path(new_uid), status: :moved_permanently
    end
  end
end
