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
    date_array_existing = []
    records.each do |record|
      date_array_existing.push(month_to_int(record.month))
    end
    date_array_existing.sort
    last_month = int_to_month(date_array_existing.last)
    current_month = int_to_month(date_array_existing.first)

    date_array = []
    while current_month.year != last_month.year || current_month.month != last_month.month
      date_array.push(month_to_int(current_month))
      current_month = current_month.next_month
    end
    date_array.push(month_to_int(current_month))
    date_array
  end

  def record_objects
    # return {date: {rating: x, rank: y}}
    r = {}
    records.each do |record|
      r[month_to_int(record.month)] = {"rating": record.standard_rating, "rank": record.standard_rank}
    end
    r.to_json
  end

  def best_rating
    best_rating = 0
    records.each do |record|
      best_rating = [best_rating, record.standard_rating].max
    end
    best_rating
  end

  def current_rating
    r = records
    r.sort do |a, b|
      a.month <=> b.month
    end
    r.last.standard_rating
  end

  private

  def month_to_int(month)
    month.year * 100 + month.month
  end

  def int_to_month(date)
    # date = YYYYMM
    year = date / 100
    month = date % 100
    Date.new(year, month, 1)
  end
end
