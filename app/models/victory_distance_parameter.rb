# frozen_string_literal: true

class VictoryDistanceParameter
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveRecord::AttributeAssignment
  include ActiveRecord::AttributeMethods::Write

  attribute :player1, :string, default: "Nanjo Ryosuke"
  attribute :player2, :string

  def initialize(params)
    super(params.permit(:player1, :player2))
  end
end
