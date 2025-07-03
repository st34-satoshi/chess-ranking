# frozen_string_literal: true

class RankingDifferencesController < ApplicationController
  def index
    @search_parameter = search_params
    current_month = @search_parameter.month
    last_month = current_month.last_month
    
    # Get current month records
    @current_records = Record.year_is(current_month.year)
                             .month_is(current_month.month)
                             .ordered
                             .page(params[:page])
                             .per(50)
    
    # Get last month records for the same players
    player_ids = @current_records.map(&:player_id)
    @last_month_records = Record.in_order_of(:player_id, player_ids)
                                .year_is(last_month.year)
                                .month_is(last_month.month)
    
    # Calculate differences for display
    @records_with_differences = calculate_differences(@current_records, @last_month_records)
  end

  private

  def search_params
    PlayerSearchParameter.new(params.fetch(:player_search_parameter, {}))
  end

  def calculate_differences(current_records, last_month_records)
    results = []
    last_month_hash = last_month_records.index_by(&:player_id)
    
    current_records.each do |current_record|
      last_record = last_month_hash[current_record.player_id]
      
      if last_record
        rank_diff = current_record.standard_rank - last_record.standard_rank
        rating_diff = current_record.standard_rating - last_record.standard_rating
        
        results << {
          current: current_record,
          last: last_record,
          rank_difference: rank_diff,
          rating_difference: rating_diff,
          rank_change_type: rank_change_type(rank_diff),
          rating_change_type: rating_change_type(rating_diff)
        }
      else
        results << {
          current: current_record,
          last: nil,
          rank_difference: nil,
          rating_difference: nil,
          rank_change_type: :new,
          rating_change_type: :new
        }
      end
    end
    
    results
  end

  def rank_change_type(diff)
    return :same if diff == 0
    return :improved if diff < 0  # Lower rank number = better rank
    :declined
  end

  def rating_change_type(diff)
    return :same if diff == 0
    return :improved if diff > 0
    :declined
  end
end