class CreateMatches < ActiveRecord::Migration[7.0]
  def change
    create_table :matches do |t|
      t.references :won, null: false, foreign_key: { to_table: :players }
      t.references :lost, null: false, foreign_key: { to_table: :players }

      t.timestamps
    end
  end
end
