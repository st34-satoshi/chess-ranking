class PlayersComparison < ApplicationRecord
  generate_public_uid
  before_save :clean_result_url

  def to_param
    public_uid
  end

  private

  def clean_result_url
    self.result_url = result_url&.strip
    self.result_url = result_url&.split('?')&.first
  end
end
