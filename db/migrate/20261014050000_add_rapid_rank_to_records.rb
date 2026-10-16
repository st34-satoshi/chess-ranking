# frozen_string_literal: true

class AddRapidRankToRecords < ActiveRecord::Migration[7.0]
  def change
    add_column :records, :rapid_rank, :integer
  end
end
