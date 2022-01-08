# frozen_string_literal: true

class Player < ApplicationRecord
  scope :name_en_has, ->(name) { where('lower(name_en) like ?', "%#{name&.downcase}%") }
  scope :name_jp_has, ->(name) { where('lower(name_jp) like ?', "%#{name&.downcase}%") }
  scope :active, ->(act) { where(active: act) }
  scope :standard_rating_between, ->(from, to) { where(rating_standard: from..to) }
  scope :ordered, -> { order(rating_standard: 'DESC') }

  def self.players_name_has(name)
    Player.all.name_en_has(name).or(Player.all.name_jp_has(name))
  end

  def self.filtered_players(search_param)
    players = players_name_has(search_param.name).standard_rating_between(search_param.rating_lower,
                                                                          search_param.rating_upper)
    if search_param.active?
      players = players.active('Act')
    elsif search_param.inactive?
      players = players.active(nil)
    end
    players
  end
end
