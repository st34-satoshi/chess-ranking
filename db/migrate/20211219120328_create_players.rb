# frozen_string_literal: true

class CreatePlayers < ActiveRecord::Migration[5.2]
  def change
    create_table :players do |t|
      t.string :ncs_id
      t.string :name_en
      t.string :name_jp
      t.string :public_uid

      t.timestamps
    end
    add_index :players, :public_uid, unique: true
  end
end
