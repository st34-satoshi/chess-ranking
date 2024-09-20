# frozen_string_literal: true

namespace :to_csv do
  desc 'DB to CSV. player.ncs_id, player.public_uid'
  task palyers_to_csv: :environment do
    puts 'start'

    require 'csv'

    CSV.open('players.csv', 'w') do |csv|
      csv << %w[ncs_id public_uid]  # Header row
      Player.all.each do |player|
        csv << [player.ncs_id, player.public_uid]
      end
    end
    puts 'CSV file "players.csv" has been created.'
  end

  desc 'CSV to DB. player.ncs_id, player.public_uid'
  task palyers_csv_to_db: :environment do
    puts 'start'

    require 'csv'

    CSV.foreach('players.csv', headers: true) do |row|
      Redirect.create!(
        ncs_id: row['ncs_id'],
        public_uid: row['public_uid']
      )
    end
    puts 'CSV data has been imported into the Redirect table.'
  end
end
