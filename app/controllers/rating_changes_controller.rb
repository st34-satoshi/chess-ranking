class RatingChangesController < ApplicationController
  def index
    @search_parameter = search_params
    current_month = @search_parameter.month
    last_month = current_month.last_month
    current_records = Record.year_is(current_month.year).month_is(current_month.month)
    last_records = Record.year_is(last_month.year).month_is(last_month.month)
    last_records_map = last_records.index_by(&:player_id)

    @changes = []
    current_records.each do |record|
      prev = last_records_map[record.player_id]
      next unless prev

      diff = record.standard_rating - prev.standard_rating
      @changes << { record: record, diff: diff }
    end
    @changes.sort_by! { |c| -c[:diff] }
  end

  private

  def search_params
    PlayerSearchParameter.new(params.fetch(:player_search_parameter, {}))
  end
end
