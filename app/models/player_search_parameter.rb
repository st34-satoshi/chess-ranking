# frozen_string_literal: true

class PlayerSearchParameter
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveRecord::AttributeAssignment
  include ActiveRecord::AttributeMethods::Write

  attribute :name, :string, default: nil
  attribute :rating_upper, :integer, default: 3000
  attribute :rating_lower, :integer, default: 0
  attribute :active, :string, default: 'all'
  attribute :month, :date, default: Record.latest_month

  def initialize(params)
    super(params.permit(:name, :rating_upper, :rating_lower, :active, :month))
  end

  def month=(value)
    # value example: 2021-12
    y = value.split('-')[0].to_i
    m = value.split('-')[1].to_i
    write_attribute(:month, Date.new(y, m, 5))  # any day is ok
  end

  def selected_month
    "#{month.year}-#{month.month}"
  end

  def active?
    active == 'active'
  end

  def inactive?
    active == 'inactive'
  end
end
