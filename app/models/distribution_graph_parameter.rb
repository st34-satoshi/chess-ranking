# frozen_string_literal: true

class DistributionGraphParameter
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveRecord::AttributeAssignment
  include ActiveRecord::AttributeMethods::Write

  attribute :range, :integer, default: 100
  attribute :month_1, :date, default: Record.maximum(:month)
  attribute :month_2, :date, default: Date.new(2019, 4, 5)

  def initialize(params)
    super(params.permit(:range, :month_1, :month_2))
  end

  def month_1=(value)
    # value example: 2021-12
    y = value.split('-')[0].to_i
    m = value.split('-')[1].to_i
    write_attribute(:month_1, Date.new(y, m, 5))  # any day is ok
  end

  def month_2=(value)
    # value example: 2021-12
    y = value.split('-')[0].to_i
    m = value.split('-')[1].to_i
    write_attribute(:month_2, Date.new(y, m, 5))  # any day is ok
  end

  def selected_month_1
    "#{month_1.year}-#{month_1.month}"
  end

  def selected_month_2
    "#{month_2.year}-#{month_2.month}"
  end
end
