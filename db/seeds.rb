# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

CSV.foreach('lib/assets/ranking-2021-12.csv') do |row|
    next if row[0].length < 8
    next if row[0][0] != 'N'
    Player.create(name_en: row[1], name_jp: row[2], rating_standard: row[4].to_i, active: row[10])
end
