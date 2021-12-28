class CreatePlayers < ActiveRecord::Migration[5.2]
  def change
    create_table :players do |t|
      t.string :name_en
      t.string :name_jp
      t.integer :rating_standard
      t.string :active

      t.timestamps
    end
  end
end
