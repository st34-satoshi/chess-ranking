# frozen_string_literal: true

class Player < ApplicationRecord
  has_many :records, dependent: :destroy

  scope :name_en_has, ->(name) { where('lower(name_en) like ?', "%#{name&.downcase}%") }
  scope :name_jp_has, ->(name) { where('lower(name_jp) like ?', "%#{name&.downcase}%") }

  def self.players_name_has(name)
    Player.all.name_en_has(name).or(Player.all.name_jp_has(name))
  end
end
