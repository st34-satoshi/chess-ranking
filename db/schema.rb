# frozen_string_literal: true

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20_220_108_090_134) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'players', force: :cascade do |t|
    t.string 'ncs_id'
    t.string 'name_en'
    t.string 'name_jp'
    t.string 'public_uid', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['public_uid'], name: 'index_players_on_public_uid', unique: true
  end

  create_table 'records', force: :cascade do |t|
    t.bigint 'player_id'
    t.integer 'coefficient_k', default: 40, null: false
    t.integer 'standard_rating', default: 0, null: false
    t.integer 'standard_games', default: 0, null: false
    t.integer 'standard_ranking'
    t.integer 'standard_rank'
    t.integer 'rapid_rating', default: 0, null: false
    t.integer 'rapid_games', default: 0, null: false
    t.boolean 'member', default: true, null: false
    t.boolean 'active', default: false, null: false
    t.date 'month', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['player_id'], name: 'index_records_on_player_id'
  end

  add_foreign_key 'records', 'players'
end
