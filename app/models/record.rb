class Record < ApplicationRecord
  belongs_to :player

  def member=(value)
    write_attribute(:member, false)
  end

  def active=(value)
    write_attribute(:active, false)
  end
end
