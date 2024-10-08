# frozen_string_literal: true

class Player < ApplicationRecord
  has_many :records, dependent: :destroy

  has_many :won_match, class_name: 'Match', foreign_key: 'won_id'
  has_many :won_players, through: :won_match, source: :lost

  has_many :lost_match, class_name: 'Match', foreign_key: 'lost_id'
  has_many :lost_players, through: :lost_match, source: :won

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
    date_array_existing = date_array_existing.sort
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
    this_records.each do |record|
      next if record.standard_rating.zero?

      r[month_to_int(record.month)] = { rating: record.standard_rating, rank: record.standard_rank }
    end
    r.to_json
  end

  def best_rating
    best_rating = 0
    this_records.each do |record|
      best_rating = [best_rating, record.standard_rating].max
    end
    best_rating
  end

  def current_rating
    r = this_records
    r = r.sort do |a, b|
      a.month <=> b.month
    end
    r.last.standard_rating
  end

  def best_rank
    best_rank = 9_999_999
    this_records.each do |record|
      best_rank = [best_rank, record.standard_rank].min
    end
    best_rank
  end

  def current_rank
    r = this_records
    r = r.sort do |a, b|
      a.month <=> b.month
    end
    r.last.standard_rank
  end

  def name_of(locale)
    return name_jp if locale == :ja

    name_en
  end

  private

  def month_to_int(month)
    (month.year * 100) + month.month
  end

  def int_to_month(date)
    # date = YYYYMM
    year = date / 100
    month = date % 100
    Date.new(year, month, 1)
  end

  def this_records
    @this_records ||= records
  end
end
