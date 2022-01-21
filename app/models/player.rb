# frozen_string_literal: true

class Player < ApplicationRecord
  has_many :records, dependent: :destroy
  generate_public_uid

  scope :name_en_has, ->(name) { where('lower(name_en) like ?', "%#{name&.downcase}%") }
  scope :name_jp_has, ->(name) { where('lower(name_jp) like ?', "%#{name&.downcase}%") }

  def to_param
    public_uid
  end

  def self.players_name_has(name)
    Player.all.name_en_has(name).or(Player.all.name_jp_has(name))
  end
end
