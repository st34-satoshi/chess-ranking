# frozen_string_literal: true

require 'csv'

# rubocop:disable Metrics/BlockLength
namespace :victory_distance do
  desc 'Save match results'
  task save: :environment do
    puts 'Saving match results'
    puts "match size: #{Match.count}"

    CSV.foreach('./lib/data/games.tsv', col_sep: "\t").with_index do |row, i|
      puts "Processing row: #{i}" if (i % 100).zero?
      result, white_name, white_ncs_id, black_name, black_ncs_id = row
      next if (white_ncs_id[0] == 'F') || (black_ncs_id[0] == 'F')

      # get player
      white = Player.find_by(ncs_id: white_ncs_id)
      if white.nil?
        puts "\e[33mWarning: White player not found: #{white_name}, #{white_ncs_id}\e[0m"
        next
      end
      black = Player.find_by(ncs_id: black_ncs_id)
      if black.nil?
        puts "\e[33mWarning: Black player not found: #{black_name}, #{black_ncs_id}\e[0m"
        next
      end

      if result == '1'
        white.lost_players << black
      elsif result == '0'
        black.lost_players << white
      elsif result != '0.5'
        puts "\e[31mResult is unexpected: #{result}\e[0m"
      end
    end

    puts 'Finished'
    puts "match size: #{Match.count}"
  end
end
# rubocop:enable Metrics/BlockLength
