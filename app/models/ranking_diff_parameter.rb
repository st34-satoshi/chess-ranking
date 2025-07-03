class RankingDiffParameter
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveRecord::AttributeAssignment
  include ActiveRecord::AttributeMethods::Write

  attribute :month, :date, default: Record.latest_month

  def initialize(params)
    super(params.permit(:month))
  end

  def month=(value)
    y = value.split('-')[0].to_i
    m = value.split('-')[1].to_i
    write_attribute(:month, Date.new(y, m, 5))
  end

  def selected_month
    "#{month.year}-#{month.month}"
  end
end
