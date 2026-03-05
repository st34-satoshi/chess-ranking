# frozen_string_literal: true

require 'csv'

# Load players and records from lib/data/*.csv (created by rake data:export_to_csv)
[
  ['players', Player],
  ['records', Record]
].each do |table_name, model|
  file_path = Rails.root.join('lib', 'data', "#{table_name}.csv")

  next unless File.exist?(file_path)

  columns = model.column_names
  batch_size = 1000
  batch = []
  count = 0

  ActiveRecord::Base.transaction do
    CSV.foreach(file_path, headers: true) do |row|
      attrs = columns.to_h { |col| [col, row[col].presence] }.compact
      record = model.new(attrs)
      batch << record.attributes.slice(*columns)

      if batch.size >= batch_size
        model.insert_all(batch)
        count += batch.size
        batch = []
      end
    end
    model.insert_all(batch) if batch.any?
    count += batch.size
  end

  puts "Loaded #{count} #{table_name} from #{file_path}"
end
