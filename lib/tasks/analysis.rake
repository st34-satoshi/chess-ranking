# frozen_string_literal: true

namespace :analysis do
  desc "Diff between oldest and latest player rating"
  task diff_rating: :environment do
    puts 'starat'

    require 'csv'

    CSV.open('player_rating_diff.csv', 'w') do |csv|
      csv << ['diff', 'ncs_id', 'name']  # Header row
      Player.all.each do |player|
        diff = player.records.last.standard_rating - player.records.first.standard_rating
        csv << [diff, player.ncs_id, player.name_en]
      end
    end

    puts 'Task completed.'
  end
end
