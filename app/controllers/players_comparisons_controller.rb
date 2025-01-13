class PlayersComparisonsController < ApplicationController
  def index
    @players_comparison = PlayersComparison.first
  end

  def show
    @players_comparison = PlayersComparison.find_by!(public_uid: params[:id])
  end

  def create
    @players_comparison = PlayersComparison.new(players_comparison_params)
    if @players_comparison.valid?
      if @players_comparison.save
        redirect_to players_comparison_path(@players_comparison)
      else
        flash.now[:alert] = @players_comparison.errors.full_messages.join(", ")
        render :index
      end
    else
      flash.now[:alert] = @players_comparison.errors.full_messages.join(", ")
      render :index
    end
  end

  private

  def players_comparison_params
    params.require(:players_comparison).permit(:input_text, :result_url, :contain_result_url)
  end
end
