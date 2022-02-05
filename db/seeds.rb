# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

def add_rank(records)
  rank = 1
  higher_rank = 99_999
  records.each_with_index do |record, i|
    if record.standard_rating < higher_rank # same rating same rank
      higher_rank = record.standard_rating
      rank = i + 1
    end
    record.update(standard_rank: rank)
  end
end

def create_record_2019(file_name, date)
  # file_name: rating-YYYY-MM-DD
  # for 2019-03 and 2019-04 data
  CSV.foreach("lib/assets/#{file_name}", headers: true) do |row|
    next unless row['ID'] # add this data later
    next if row['ID'][0] != 'N'

    player = Player.find_by(ncs_id: row['ID'])
    player ||= Player.create(ncs_id: row['ID'], name_en: row['Name'], name_jp: row['Kanji'])

    Record.create(player_id: player.id, standard_rating: row['Rating'], standard_games: row['Games'], month: date)
  end
end

def create_record_2020(file_name, date)
  # file_name: rating-YYYY-MM-DD
  # for 2019-06, 2019-07, ... 2019-12, 2020-01, 2020-02, 2020-03
  CSV.foreach("lib/assets/#{file_name}") do |row|
    name = row[0]
    kanji = row[1]
    k = row[2]
    rating = row[3]
    games = row[4]
    games ||= 0
    id = row[5]
    next unless id
    next unless rating
    next if id.length < 8
    next if id[0] != 'N'

    player = Player.find_by(ncs_id: id)
    player ||= Player.create(ncs_id: id, name_en: name, name_jp: kanji)

    Record.create(player_id: player.id, coefficient_k: k, standard_rating: rating, standard_games: games, month: date)
  end
end

def create_record_2020_b(file_name, date)
  # file_name: rating-YYYY-MM-DD
  # for 2019-05, 2020-04, 2020-05, ..., 2020-12
  CSV.foreach("lib/assets/#{file_name}") do |row|
    id = row[0]
    name = row[1]
    kanji = row[2]
    k = row[3]
    rating = row[4]
    games = row[5]
    next unless id
    next if id.length < 8
    next if id[0] != 'N'

    player = Player.find_by(ncs_id: id)
    player ||= Player.create(ncs_id: id, name_en: name, name_jp: kanji)

    Record.create(player_id: player.id, coefficient_k: k, standard_rating: rating, standard_games: games, month: date)
  end
end

def create_record_2021(file_name, date)
  # file_name: rating-YYYY-MM-DD
  CSV.foreach("lib/assets/#{file_name}") do |row|
    next unless row
    next unless row[0]
    next unless row[4] # standard rating is nil
    next if row.length < 8
    next if row[0].length < 8
    next if row[0][0] != 'N'

    player = Player.find_by(ncs_id: row[0])
    player ||= Player.create(ncs_id: row[0], name_en: row[1], name_jp: row[2])

    rapid_rating = row[7]
    rapid_rating ||= 0
    rapid_games = row[8]
    rapid_games ||= 0
    standard_games = row[5]
    standard_games ||= 0

    Record.create(player_id: player.id, coefficient_k: row[3], standard_rating: row[4], standard_games: standard_games,
                  standard_ranking: row[6], rapid_rating: rapid_rating, rapid_games: rapid_games, member: row[9],
                  active: row[10], month: date)
  end
end

def create_date(file_name)
  d = file_name.split('-')
  year = d[1].to_i
  month = d[2].to_i
  day = d[3].to_i
  day = 1 if day.zero?
  Date.new(year, month, day)
end

def string_include?(words, str)
  words.each do |word|
    return true if str.include?(word)
  end
  false
end

def create_record(file_name)
  puts file_name
  date = create_date(file_name)
  return if Record.month_array.include?("#{date.year}-#{date.month}") # skip exist data

  if file_name.include?('2019-03') || file_name.include?('2019-04')
    create_record_2019(file_name, date)
  elsif string_include?(%w[2020-01 2020-02 2020-03],
                        file_name) || (file_name.include?('2019') && !file_name.include?('2019-05'))
    create_record_2020(file_name, date)
  elsif file_name.include?('2019-05') || file_name.include?('2020')
    create_record_2020_b(file_name, date)
  else
    create_record_2021(file_name, date)
  end
  records = Record.all.year_is(date.year).month_is(date.month).ordered
  add_rank(records)
end

Dir.open('./lib/assets/') do |dir|
  dir.each do |file_name|
    create_record(file_name) if File.extname(file_name) == '.csv'
  end
end
