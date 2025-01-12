class PlayersComparisonsController < ApplicationController
  def index
    @players_comparison = PlayersComparison.first
  end

  def show
    @players_comparison = PlayersComparison.find_by!(public_uid: params[:id])
  end

  def create
    @players_comparison = PlayersComparison.new(players_comparison_params)
    if @players_comparison.save
      redirect_to players_comparisons_path
      # redirect_to players_comparison_path(@players_comparison)
    else
      render :index
    end
  end

  private

  def players_comparison_params
    params.require(:players_comparison).permit(:input_text, :result_url)
  end
end