# frozen_string_literal: true

class CreateRecords < ActiveRecord::Migration[5.2]
  def change
    create_table :records do |t|
      t.references :player, foreign_key: true
      t.integer :coefficient_k, null: false, default: 40
      t.integer :standard_rating, null: false, default: 0
      t.integer :standard_games, null: false, default: 0
      t.integer :standard_ranking # decided by NCS
      t.integer :standard_rank # decided by this code
      t.integer :rapid_rating, null: false, default: 0
      t.integer :rapid_games, null: false, default: 0
      t.boolean :member, null: false, default: true
      t.boolean :active, null: false, default: false
      t.date :month, null: false

      t.timestamps
    end
  end
end
