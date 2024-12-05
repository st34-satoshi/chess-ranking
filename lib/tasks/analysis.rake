# frozen_string_literal: true

namespace :analysis do
  desc 'Diff between oldest and latest player rating'
  task diff_rating: :environment do
    puts 'start'

    require 'csv'

    CSV.open('player_rating_diff.csv', 'w') do |csv|
      csv << %w[diff ncs_id name] # Header row
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

  desc 'find a player who has no rating at the last month record'
  task find_player_no_rating_at_last_month: :environment do
    puts 'start'

    Player.all.each do |player|
      last_month_record = player.records.last
      next if last_month_record.nil?

      last_month = Date.today.prev_month.beginning_of_month

      if last_month_record.month.month == last_month.month && last_month_record.month.year == last_month.year
        puts "player: #{player.name_en}"
      end
    end

    puts 'Task completed.'
  end
end
