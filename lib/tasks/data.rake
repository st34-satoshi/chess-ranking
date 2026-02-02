# frozen_string_literal: true

namespace :data do
  desc 'Remove records for a specific month (usage: rake "data:remove[2026-02-01]")'
  task :remove, [:month] => :environment do |_t, args|
    month_str = args[:month]

    unless month_str
      puts 'Error: Please specify a month.'
      puts 'Usage: rake "data:remove[2026-02-01]"'
      exit 1
    end

    date = begin
      Date.parse(month_str)
    rescue ArgumentError
      nil
    end

    unless date
      puts "Error: Invalid date format: #{month_str}"
      exit 1
    end

    count = Record.where(month: date).delete_all
    puts "Removed #{count} record(s) for #{date}."
  end

  desc 'Import data from a specific CSV file (usage: rake data:import[filename.csv])'
  task :import, [:file_name] => :environment do |_t, args|
    file_name = args[:file_name]

    unless file_name
      puts 'Error: Please specify a file name.'
      puts 'Usage: rake data:import[filename.csv]'
      exit 1
    end

    file_path = Rails.root.join('lib/assets', file_name)

    unless File.exist?(file_path)
      puts "Error: File not found: #{file_path}"
      exit 1
    end

    unless File.extname(file_name) == '.csv'
      puts 'Error: File must be a CSV file (.csv extension)'
      exit 1
    end

    puts "Importing data from #{file_name}..."
    RecordImporter.create_record(file_name)
    puts 'Import completed.'
  end

  desc 'Fill records.previous_*_rating and *_delta from prev record per player (prev null => only update prev)'
  task fill_rating_deltas: :environment do
    player_count = Player.count
    Player.find_each.with_index(1) do |player, index|
      puts "Processing player #{index} of #{player_count}"
      prev_std = nil
      prev_rapid = nil
      player.records.order(:month).find_each do |record|
        standard_delta = record.standard_rating - (prev_std || 0)
        rapid_delta = record.rapid_rating - (prev_rapid || 0)
        record.update!(
          previous_standard_rating: prev_std,
          previous_rapid_rating: prev_rapid,
          standard_rating_delta: standard_delta,
          rapid_rating_delta: rapid_delta
        )
        prev_std = record.standard_rating
        prev_rapid = record.rapid_rating
      end
    end
  end
end
