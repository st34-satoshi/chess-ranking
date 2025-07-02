# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

# Clear existing data when seeding in development/test
if Rails.env.development? || Rails.env.test?
  puts "Clearing existing data..."
  Match.destroy_all
  Record.destroy_all
  PlayersComparison.destroy_all
  Redirect.destroy_all
  Player.destroy_all
  
  puts "Creating seed data for development and test..."
  
  # Create sample players with realistic names and ratings
  players_data = [
    { ncs_id: "NCS001", name_en: "Magnus Carlsen", name_jp: "マグヌス・カールセン" },
    { ncs_id: "NCS002", name_en: "Hikaru Nakamura", name_jp: "中村光" },
    { ncs_id: "NCS003", name_en: "Fabiano Caruana", name_jp: "ファビアーノ・カルアナ" },
    { ncs_id: "NCS004", name_en: "Ding Liren", name_jp: "丁立人" },
    { ncs_id: "NCS005", name_en: "Ian Nepomniachtchi", name_jp: "イアン・ネポムニャシチ" },
    { ncs_id: "NCS006", name_en: "Anish Giri", name_jp: "アニシュ・ギリ" },
    { ncs_id: "NCS007", name_en: "Maxime Vachier-Lagrave", name_jp: "マキシム・ヴァシエ＝ラグラーヴ" },
    { ncs_id: "NCS008", name_en: "Wesley So", name_jp: "ウェスリー・ソー" },
    { ncs_id: "NCS009", name_en: "Levon Aronian", name_jp: "レヴォン・アロニアン" },
    { ncs_id: "NCS010", name_en: "Teimour Radjabov", name_jp: "テイムール・ラジャボフ" },
    { ncs_id: "NCS011", name_en: "Sergey Karjakin", name_jp: "セルゲイ・カリャーキン" },
    { ncs_id: "NCS012", name_en: "Alexander Grischuk", name_jp: "アレクサンドル・グリシュク" },
    { ncs_id: "NCS013", name_en: "Vidit Gujrathi", name_jp: "ヴィディト・グジュラティ" },
    { ncs_id: "NCS014", name_en: "Pentala Harikrishna", name_jp: "ペンタラ・ハリクリシュナ" },
    { ncs_id: "NCS015", name_en: "Richard Rapport", name_jp: "リチャード・ラポート" }
  ]
  
  players = players_data.map do |data|
    Player.create!(data)
  end
  
  puts "Created #{players.length} players"
  
  # Create historical records (ratings progression over several months)
  base_ratings = [2850, 2810, 2800, 2790, 2780, 2770, 2760, 2750, 2740, 2730, 2720, 2710, 2700, 2690, 2680]
  months = [
    Date.new(2024, 10, 1),
    Date.new(2024, 11, 1), 
    Date.new(2024, 12, 1),
    Date.new(2025, 1, 1),
    Date.new(2025, 2, 1),
    Date.new(2025, 3, 1),
    Date.new(2025, 4, 1),
    Date.new(2025, 5, 1),
    Date.new(2025, 6, 1)
  ]
  
  players.each_with_index do |player, player_index|
    base_rating = base_ratings[player_index] || (2600 + rand(100))
    
    months.each_with_index do |month, month_index|
      # Add some rating variation over time
      rating_variation = rand(-30..30)
      final_rating = base_rating + rating_variation
      
      # Ensure minimum rating
      final_rating = [final_rating, 1200].max
      
      # Progressive improvement for some players, decline for others
      if player_index.even?
        final_rating += month_index * 5  # Gradual improvement
      else
        final_rating -= month_index * 2  # Gradual decline
      end
      
      Record.create!(
        player: player,
        coefficient_k: [16, 20, 24, 32, 40].sample,
        standard_rating: final_rating,
        standard_games: rand(15..50),
        rapid_rating: final_rating - rand(20..80),
        rapid_games: rand(10..40),
        member: [true, false].sample,
        active: month_index >= 6 ? true : [true, false].sample, # Recent months more likely to be active
        month: month
      )
    end
  end
  
  # Add ranks to records
  months.each do |month|
    Record.add_rank(month)
  end
  
  puts "Created historical records for #{months.length} months"
  
  # Create some matches between players
  50.times do
    won_player = players.sample
    lost_player = players.sample
    next if won_player == lost_player
    
    Match.create!(
      won: won_player,
      lost: lost_player
    )
  end
  
  puts "Created 50 match records"
  
  # Create some player comparisons
  comparison_data = [
    {
      players_list: [players[0].id, players[1].id, players[2].id].to_json,
      input_text: "Magnus Carlsen vs Hikaru Nakamura vs Fabiano Caruana",
      is_default_data: true
    },
    {
      players_list: [players[3].id, players[4].id].to_json,
      input_text: "Ding Liren vs Ian Nepomniachtchi",
      is_default_data: false
    },
    {
      players_list: [players[5].id, players[6].id, players[7].id, players[8].id].to_json,
      input_text: "Young stars comparison: Giri, MVL, Wesley So, Aronian",
      is_default_data: false
    }
  ]
  
  comparison_data.each do |data|
    PlayersComparison.create!(data)
  end
  
  puts "Created #{comparison_data.length} player comparisons"
  
  # Create some redirects
  redirect_data = [
    { ncs_id: "OLD001", public_uid: players[0].public_uid },
    { ncs_id: "OLD002", public_uid: players[1].public_uid },
    { ncs_id: "OLD003", public_uid: players[2].public_uid }
  ]
  
  redirect_data.each do |data|
    Redirect.create!(data)
  end
  
  puts "Created #{redirect_data.length} redirects"
  
  puts "Seed data creation completed!"
  puts "Players: #{Player.count}"
  puts "Records: #{Record.count}"
  puts "Matches: #{Match.count}"
  puts "Comparisons: #{PlayersComparison.count}"
  puts "Redirects: #{Redirect.count}"
  
else
  # Production environment - load from CSV files as before
  require 'csv'
  
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
end