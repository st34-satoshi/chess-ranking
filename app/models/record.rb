class Record < ApplicationRecord
  belongs_to :player

  scope :active, ->(act) { where(active: act) }
  scope :standard_rating_between, ->(from, to) { where(standard_rating: from..to) }
  scope :ordered, -> { order(standard_rating: 'DESC') }

  def self.players_name_has(name)
    Player.all.name_en_has(name).or(Player.all.name_jp_has(name))
  end

  def self.filtered_records(search_param)
    records = Record.joins(:player).merge(Player.players_name_has(search_param.name)).standard_rating_between(search_param.rating_lower, search_param.rating_upper)

    if search_param.active?
      records = records.active(true)
    elsif search_param.inactive?
      records = records.active(false)
    end
    records
  end

  def member=(value)
    write_attribute(:member, false)
  end

  def active=(value)
    write_attribute(:active, false)
  end
end
