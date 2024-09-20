class Redirect < ApplicationRecord
  def self.new_player_public_uid(old_uid)
    ncs = find_by(public_uid: old_uid)&.ncs_id
    return nil if ncs.nil?

    Player.find_by(ncs_id: ncs)&.public_uid
  end
end
