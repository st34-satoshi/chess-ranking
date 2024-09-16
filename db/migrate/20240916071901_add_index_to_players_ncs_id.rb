# frozen_string_literal: true

class AddIndexToPlayersNcsId < ActiveRecord::Migration[7.0]
  def change
    add_index :players, :ncs_id, unique: true
  end
end
