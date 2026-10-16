# frozen_string_literal: true

module PlayersHelper
  def ranking_path
    @search_parameter.rapid? ? rapid_path : players_path
  end

  def ranking_title
    @search_parameter.rapid? ? t('views.players.rapid_title') : t('views.players.title')
  end

  def records_with_previous_month(records, previous_records)
    res = []
    records.each do |r|
      pre = nil
      previous_records.each do |p|
        if r.player_id == p.player_id
          pre = p
          break
        end
      end
      res.push [r, pre]
    end
    res
  end
end
