class RankingDiffsController < ApplicationController
  def index
    @ranking_diff_parameter = ranking_diff_params
    month = @ranking_diff_parameter.month
    last_month = month.last_month
    current_records = Record.year_is(month.year).month_is(month.month).ordered
    previous_records = Record.year_is(last_month.year).month_is(last_month.month)

    @diffs = current_records.map do |record|
      prev = previous_records.find { |p| p.player_id == record.player_id }
      next unless prev
      {
        player: record.player,
        current_rank: record.standard_rank,
        last_rank: prev.standard_rank,
        diff: prev.standard_rank - record.standard_rank
      }
    end.compact.sort_by { |h| -h[:diff] }
  end

  private

  def ranking_diff_params
    RankingDiffParameter.new(params.fetch(:ranking_diff_parameter, {}))
  end
end
