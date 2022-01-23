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

  def dates
    # return the list of date (YYYYMM) when this player has.
    date_array = []
    records.each do |record|
      date_array.push(month_to_int(record.month))
    end
    date_array.sort
  end

  def record_objects
    # return {date: {rating: x, rank: y}}
    r = {}
    records.each do |record|
      r[month_to_int(record.month)] = {"rating": record.standard_rating, "rank": record.standard_rank}
    end
    r.to_json
  end

  private

  def month_to_int(month)
    month.year * 100 + month.month
  end
end
