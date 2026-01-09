# frozen_string_literal: true

namespace :data do
  desc "Import data from a specific CSV file (usage: rake data:import[filename.csv])"
  task :import, [:file_name] => :environment do |_t, args|
    file_name = args[:file_name]
    
    unless file_name
      puts "Error: Please specify a file name."
      puts "Usage: rake data:import[filename.csv]"
      exit 1
    end
    
    file_path = Rails.root.join('lib/assets', file_name)
    
    unless File.exist?(file_path)
      puts "Error: File not found: #{file_path}"
      exit 1
    end
    
    unless File.extname(file_name) == '.csv'
      puts "Error: File must be a CSV file (.csv extension)"
      exit 1
    end
    
    puts "Importing data from #{file_name}..."
    RecordImporter.create_record(file_name)
    puts "Import completed."
  end
end

