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

  def rank_record_objects
    this_records.to_h do |record|
      [month_to_int(record.month), {
        standard_rank: record.standard_rating.positive? && record.standard_rank&.positive? ? record.standard_rank : nil,
        rapid_rank: record.rapid_rating.positive? && record.rapid_rank&.positive? ? record.rapid_rank : nil
      }]
    end.to_json
  end

  def rating_record_objects
    this_records.to_h do |record|
      [month_to_int(record.month), {
        standard_rating: record.standard_rating.positive? ? record.standard_rating : nil,
        rapid_rating: record.rapid_rating.positive? ? record.rapid_rating : nil
      }]
    end.to_json
  end

  def current_rapid_rating
    rating = this_records.max_by(&:month)&.rapid_rating
    rating if rating&.positive?
  end

  def best_rapid_rating
    this_records.map(&:rapid_rating).select(&:positive?).max
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
    this_records.select { |record| record.standard_rating.positive? }
                .map(&:standard_rank).compact.select(&:positive?).min
  end

  def current_rank
    record = this_records.max_by(&:month)
    record.standard_rank if record&.standard_rating&.positive? && record.standard_rank&.positive?
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
