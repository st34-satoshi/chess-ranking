# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

# CSV.foreach('lib/assets/ranking-2021-12.csv') do |row|
#   next if row[0].length < 8
#   next if row[0][0] != 'N'

#   Player.create(ncs_id: row[0], name_en: row[1], name_jp: row[2])
# end

CSV.foreach('lib/assets/ranking-2021-12.csv') do |row|
  next if row[0].length < 8
  next if row[0][0] != 'N'

  player = Player.find_by(ncs_id: row[0])
  player = Player.create(ncs_id: row[0], name_en: row[1], name_jp: row[2]) unless player

  date = Date.new(2021, 12, 01)
  Record.create(player_id: player.id, coefficient_k: row[3], standard_rating: row[4], standard_games: row[5], standard_ranking: row[6], rapid_rating: row[7], rapid_games: row[8], member: row[9], active: row[10], month: date)
end