class PlayersComparison < ApplicationRecord
  generate_public_uid
  
  def to_param
    public_uid
  end
end
