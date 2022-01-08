class CreateRecords < ActiveRecord::Migration[5.2]
  def change
    create_table :records do |t|
      t.references :player, foreign_key: true
      t.integer :coefficient_k, null: false
      t.integer :standard_rating, null: false
      t.integer :standard_games, null: false
      t.integer :standard_ranking
      t.integer :rapid_rating, null: false
      t.integer :rapid_games, null: false
      t.boolean :member, null: false
      t.boolean :active, null: false
      t.date :month, null: false

      t.timestamps
    end
  end
end
