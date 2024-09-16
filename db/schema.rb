# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2024_09_16_134045) do
  create_table "matches", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "won_id", null: false
    t.bigint "lost_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lost_id"], name: "index_matches_on_lost_id"
    t.index ["won_id"], name: "index_matches_on_won_id"
  end

  create_table "players", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "ncs_id"
    t.string "name_en"
    t.string "name_jp"
    t.string "public_uid", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["ncs_id"], name: "index_players_on_ncs_id", unique: true
    t.index ["public_uid"], name: "index_players_on_public_uid", unique: true
  end

  create_table "records", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "player_id"
    t.integer "coefficient_k", default: 40, null: false
    t.integer "standard_rating", default: 0, null: false
    t.integer "standard_games", default: 0, null: false
    t.integer "standard_ranking"
    t.integer "standard_rank"
    t.integer "rapid_rating", default: 0, null: false
    t.integer "rapid_games", default: 0, null: false
    t.boolean "member", default: true, null: false
    t.boolean "active", default: false, null: false
    t.date "month", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["player_id"], name: "index_records_on_player_id"
  end

  add_foreign_key "matches", "players", column: "lost_id"
  add_foreign_key "matches", "players", column: "won_id"
  add_foreign_key "records", "players"
end
