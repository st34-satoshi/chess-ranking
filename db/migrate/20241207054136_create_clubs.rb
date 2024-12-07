# frozen_string_literal: true

class CreateClubs < ActiveRecord::Migration[7.0]
  def change
    create_table :clubs do |t|
      t.string :name, null: false, index: { unique: true }
      t.string :location
      t.string :representative_name
      t.string :email
      t.string :site_url
      t.string :x_url
      t.boolean :is_official, null: false, default: false

      t.timestamps
    end
  end
end
