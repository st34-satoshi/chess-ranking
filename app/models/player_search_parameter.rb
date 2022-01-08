# frozen_string_literal: true

class PlayerSearchParameter
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :name, :string, default: nil
  attribute :rating_upper, :integer, default: 3000
  attribute :rating_lower, :integer, default: 0
  attribute :active, :string, default: 'all'

  def initialize(params)
    super(params.permit(:name, :rating_upper, :rating_lower, :active))
  end

  def active?
    active == 'active'
  end

  def inactive?
    active == 'inactive'
  end
end
