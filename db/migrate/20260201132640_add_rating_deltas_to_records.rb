class AddRatingDeltasToRecords < ActiveRecord::Migration[7.0]
  def change
    add_column :records, :standard_rating_delta, :integer
    add_column :records, :rapid_rating_delta, :integer
  end
end
