# frozen_string_literal: true

class Record < ApplicationRecord
  belongs_to :player

  scope :active, ->(act) { where(active: act) }
  scope :year_is, ->(year) { where('extract(year from month) = ?', year) }
  scope :month_is, ->(month) { where('extract(month from month) = ?', month) }
  scope :standard_rating_between, ->(from, to) { where(standard_rating: from..to) }
  scope :ordered, -> { order(standard_rating: 'DESC') }

  def self.players_name_has(name)
    Player.all.name_en_has(name).or(Player.all.name_jp_has(name))
  end

  def self.filtered_records(search_param)
    records = Record.joins(:player).merge(Player.players_name_has(search_param.name)).standard_rating_between(
      search_param.rating_lower, search_param.rating_upper
    ).year_is(search_param.month.year).month_is(search_param.month.month)

    if search_param.active?
      records = records.active(true)
    elsif search_param.inactive?
      records = records.active(false)
    end
    records
  end

  def self.month_array
    # this sort may not be good. It does not work: [2021-10, 2021-9]
    Record.group(:month).count.keys.sort.map { |d| "#{d.year}-#{d.month}" } # ["2021-12", "2022-1"]
  end

  def self.latest_month
    Record.group(:month).count.keys.max
  end

  def member=(value)
    write_attribute(:member, value == 'Mem')
  end

  def active=(value)
    write_attribute(:active, value == 'Act')
  end

  def rapid_rating=(value)
    value ||= 0
    write_attribute(:rapid_rating, value)
  end
end
