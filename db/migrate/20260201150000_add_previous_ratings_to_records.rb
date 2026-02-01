# frozen_string_literal: true

class AddPreviousRatingsToRecords < ActiveRecord::Migration[7.0]
  def change
    add_column :records, :previous_standard_rating, :integer
    add_column :records, :previous_rapid_rating, :integer
  end
end
