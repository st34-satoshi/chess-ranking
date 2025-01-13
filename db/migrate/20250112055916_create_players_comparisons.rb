# frozen_string_literal: true

class CreatePlayersComparisons < ActiveRecord::Migration[7.0]
  def change
    create_table :players_comparisons do |t|
      t.string :public_uid, null: false, index: { unique: true }
      t.text :players_list
      t.string :result_url
      t.text :input_text
      t.boolean :is_default_data, default: false, null: false

      t.timestamps
    end
  end
end
