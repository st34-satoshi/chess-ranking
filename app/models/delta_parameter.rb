# frozen_string_literal: true

class DeltaParameter
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveRecord::AttributeAssignment
  include ActiveRecord::AttributeMethods::Write

  attribute :month, :date, default: -> { Record.latest_month }
  attribute :include_initial, :boolean, default: false

  def initialize(params = {})
    attrs = params.respond_to?(:permit) ? params.permit(:month, :include_initial) : params.slice(:month, 'month', :include_initial, 'include_initial')
    super(attrs)
  end

  def month=(value)
    return if value.blank?

    y = value.to_s.split('-')[0].to_i
    m = value.to_s.split('-')[1].to_i
    write_attribute(:month, Date.new(y, m, 5)) if y.positive? && m.positive?
  end

  def selected_month
    "#{month.year}-#{month.month}"
  end
end
