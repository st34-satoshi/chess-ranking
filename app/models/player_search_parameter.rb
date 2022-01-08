# frozen_string_literal: true

class PlayerSearchParameter
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveRecord::AttributeAssignment

  attribute :name, :string, default: nil
  attribute :rating_upper, :integer, default: 3000
  attribute :rating_lower, :integer, default: 0
  attribute :active, :string, default: 'all'
  attribute :month, :date, default: Record.maximum(:month)

  def initialize(params)
    super(params.permit(:name, :rating_upper, :rating_lower, :active, :month))
  end

  def active?
    active == 'active'
  end

  def inactive?
    active == 'inactive'
  end
end
