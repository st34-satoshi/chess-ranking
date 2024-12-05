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
    Record.joins(:player).merge(Player.players_name_has(search_param.name)).standard_rating_between(
      search_param.rating_lower, search_param.rating_upper
    ).year_is(search_param.month.year).month_is(search_param.month.month)
  end

  def self.non_membership_records(search_param, current_month_player_ids, records_size)
    # 今月年会員ではない人をの最後のrecordを返す
    Rails.logger.info("current_month_player_ids: #{current_month_player_ids}")
    non_membership_ids = []
    Player.players_name_has(search_param.name).where.not(id: current_month_player_ids).limit(50 - records_size).find_each do |player|
      latest_record = player.records.order(month: :desc).first
      non_membership_ids << latest_record.id if latest_record.present?
    end
    Record.in_order_of(:id, non_membership_ids)
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

  def self.add_rank(date)
    records = Record.all.year_is(date.year).month_is(date.month).ordered
    rank = 1
    higher_rank = 999_999
    records.each_with_index do |record, i|
      # same rating same rank. ex) rating is [101, 100, 100, 99]. rank is [1, 2, 2, 3]
      if record.standard_rating < higher_rank
        higher_rank = record.standard_rating
        rank = i + 1
      end
      record.update(standard_rank: rank)
    end
  end
end
