# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

# rubocop:disable all
def add_rank(records)
  rank = 1
  higher_rank = 99_999
  records.each_with_index do |record, i|
    if record.standard_rating < higher_rank # same rating same rank. ex) rating is [101, 100, 100, 99]. rank is [1, 2, 2, 3]
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
  key_index = read_header(file_name)
  CSV.foreach("lib/assets/#{file_name}") do |row|
    next unless row
    next unless get_row_value(row, key_index, :ncs_id)
    next unless get_row_value(row, key_index, :standard_rating)
    next if row.length < 4
    next if get_row_value(row, key_index, :ncs_id).length < 8
    next if get_row_value(row, key_index, :ncs_id)[0] != 'N'

    player = Player.find_by(ncs_id: get_row_value(row, key_index, :ncs_id))
    player ||= Player.create(ncs_id: get_row_value(row, key_index, :ncs_id),
                             name_en: get_row_value(row, key_index, :name_en), name_jp: get_row_value(row, key_index, :name_jp))

    rapid_rating = get_row_value(row, key_index, :rapid_rating)
    rapid_rating ||= 0
    rapid_games = get_row_value(row, key_index, :rapid_games)
    rapid_games ||= 0
    standard_games = get_row_value(row, key_index, :standard_games)
    standard_games ||= 0

    Record.create(
      player_id: player.id,
      coefficient_k: get_row_value(row, key_index, :coefficient_k),
      standard_rating: get_row_value(row, key_index, :standard_rating),
      standard_games: standard_games,
      standard_ranking: get_row_value(row, key_index, :standard_ranking),
      rapid_rating: rapid_rating,
      rapid_games: rapid_games,
      member: get_row_value(row, key_index, :member),
      active: get_row_value(row, key_index, :active),
      month: date
    )
  end
end

def get_row_value(row, key_map, symbol)
  return nil if key_map[symbol].nil?

  i = key_map[symbol]
  row[i]
end

# read header.
# return { 'key': row_index }
def read_header(file_name)
  i = 0
  CSV.foreach("lib/assets/#{file_name}") do |row|
    i += 1
    if i > 10
      raise 'error: cannot find header in 10 lines'
      return
    end
    next unless array_include_header_key?(row)

    key_map = {
      ncs_id: nil, name_en: nil, name_jp: nil,
      coefficient_k: nil, standard_rating: nil, standard_games: nil, standard_ranking: nil, rapid_rating: nil, rapid_games: nil,
      active: nil, member: nil
    }
    row.each.with_index do |c, j|
      key_map[:ncs_id] = j if c == 'ID'
      key_map[:name_en] = j if c == 'Name'
      key_map[:name_jp] = j if c == 'Kanji'
      key_map[:coefficient_k] = j if c == 'K'
      key_map[:coefficient_k] = j if c == 'ST-K'
      key_map[:standard_rating] = j if c == 'ST'
      key_map[:standard_games] = j if c == 'ST-G'
      key_map[:standard_ranking] = j if c == 'ST-R'
      key_map[:rapid_rating] = j if c == 'RP'
      key_map[:rapid_games] = j if c == 'RP-G'
      key_map[:active] = j if c == 'Act'
      key_map[:member] = j if c == 'Mem'
    end
    return key_map
  end
end

def array_include_header_key?(row)
  ncs_id = false
  name_en = false
  name_jp = false
  standard_rating = false

  row.each do |c|
    ncs_id = true if c == 'ID'
    name_en = true if c == 'Name'
    name_jp = true if c == 'Kanji'
    standard_rating = true if c == 'ST'
  end
  ncs_id && name_en && name_jp && standard_rating
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
# rubocop:enable all
