# frozen_string_literal: true

namespace :analysis do
  desc "Diff between oldest and latest player rating"
  task diff_rating: :environment do
    puts 'start'

    require 'csv'

    CSV.open('player_rating_diff.csv', 'w') do |csv|
      csv << ['diff', 'ncs_id', 'name']  # Header row
      zero_cnt = 0
      Player.all.each do |player|
        first_non_zero = player.records.find { |r| r.standard_rating != 0 }
        last_non_zero = player.records.reverse.find { |r| r.standard_rating != 0 }
        if first_non_zero.nil? || last_non_zero.nil?
          # puts "no rating #{player.name_en}"
          zero_cnt += 1
          next
        end
        diff = last_non_zero&.standard_rating.to_i - first_non_zero&.standard_rating.to_i
        csv << [diff, player.ncs_id, player.name_en]
      end
      puts "zero_cnt: #{zero_cnt}"
    end

    puts 'Task completed.'
  end
end
