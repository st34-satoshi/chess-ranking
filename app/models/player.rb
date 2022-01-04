# frozen_string_literal: true

class Player < ApplicationRecord
  scope :name_en_has, ->(name) { where('name_en like ?', "%#{name}%") }
  scope :name_jp_has, ->(name) { where('name_jp like ?', "%#{name}%") }
  scope :active, ->(act) { where(active: act) }
  scope :standard_rating_between, ->(from, to) { where(rating_standard: from..to) }
  scope :ordered, -> { order(rating_standard: 'DESC') }

  def self.players_name_has(name)
    Player.all.name_en_has(name).or(Player.all.name_jp_has(name))
  end

  # rubocop:disable Metrics/MethodLength
  def self.filtered_players(params)
    rating_lower = params[:rating_lower].to_i
    rating_upper = params[:rating_upper].to_i
    rating_upper = 3000 unless params[:rating_upper]
    players = players_name_has(params[:name]).standard_rating_between(rating_lower, rating_upper)
    if params[:active]
      if params[:active] == 'active'
        players = players.active('Act')
      elsif params[:active] != 'all'
        players = players.active(nil)
      end
    end
    players
  end
  # rubocop:enable Metrics/MethodLength
end
