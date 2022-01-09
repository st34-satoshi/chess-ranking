# frozen_string_literal: true

class CreatePlayers < ActiveRecord::Migration[5.2]
  def change
    create_table :players do |t|
      t.string :ncs_id
      t.string :name_en
      t.string :name_jp

      t.timestamps
    end
  end
end
