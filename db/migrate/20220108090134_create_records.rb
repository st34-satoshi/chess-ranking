class CreateRecords < ActiveRecord::Migration[5.2]
  def change
    create_table :records do |t|
      t.integer :ncs_id
      t.integer :coefficient_k
      t.integer :standard_rating
      t.integer :standard_games
      t.integer :standard_ranking
      t.integer :rapid_rating
      t.integer :rapid_games
      t.boolean :member
      t.boolean :active

      t.timestamps
    end
  end
end
