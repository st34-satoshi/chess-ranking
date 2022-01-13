# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

def create_record(file_name)
  # file_name: rating-YYYY-MM-DD
  d = file_name.split('-')
  year = d[1].to_i
  month = d[2].to_i
  day = d[3].to_i
  date = Date.new(year, month, day)
  CSV.foreach("lib/assets/#{file_name}") do |row|
    next if row[0].length < 8
    next if row[0][0] != 'N'

    player = Player.find_by(ncs_id: row[0])
    player = Player.create(ncs_id: row[0], name_en: row[1], name_jp: row[2]) unless player

    Record.create(player_id: player.id, coefficient_k: row[3], standard_rating: row[4], standard_games: row[5], standard_ranking: row[6], rapid_rating: row[7], rapid_games: row[8], member: row[9], active: row[10], month: date)
  end
  records = Record.all.year_is(year).month_is(month).ordered
  rank = 1
  higher_rank = 99999
  records.each_with_index do | record, i |
    if record.standard_rating < higher_rank  # same rating same rank
      higher_rank = record.standard_rating
      rank = i + 1
    end
    record.update(standard_rank: rank)
  end
end

Dir.open('./lib/assets/') do |dir|
  for file_name in dir
    create_record(file_name) if File.extname(file_name) == ".csv"
  end
end