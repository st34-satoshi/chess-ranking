# frozen_string_literal: true

namespace :to_csv do
  desc "DB to CSV. player.ncs_id, player.public_uid"
  task palyers_to_csv: :environment do
    puts 'start'

    require 'csv'

    CSV.open('players.csv', 'w') do |csv|
      csv << ['ncs_id', 'public_uid']  # Header row
      Player.all.each do |player|
        csv << [player.ncs_id, player.public_uid]
      end
    end
    puts 'CSV file "players.csv" has been created.'
  end
end
