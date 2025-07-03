# frozen_string_literal: true

require 'test_helper'

class RankingDifferencesControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get ranking_differences_path
    assert_response :success
  end

  test 'should get index with search parameters' do
    # Create test data
    player = players(:one)
    current_month = Date.current.beginning_of_month
    last_month = current_month.last_month

    # Create current month record
    current_record = Record.create!(
      player: player,
      month: current_month,
      standard_rating: 1500,
      standard_rank: 1
    )

    # Create last month record
    last_record = Record.create!(
      player: player,
      month: last_month,
      standard_rating: 1450,
      standard_rank: 2
    )

    get ranking_differences_path, params: {
      player_search_parameter: {
        month: "#{current_month.year}-#{current_month.month}"
      }
    }
    
    assert_response :success
    assert_select 'table.table'
    assert_select 'th', text: 'Current Rank'
    assert_select 'th', text: 'Rank Change'
    assert_select 'th', text: 'Current Rating'
    assert_select 'th', text: 'Rating Change'
  end

  test 'should handle players with no previous month data' do
    # Create test data for a new player
    player = players(:two)
    current_month = Date.current.beginning_of_month

    # Create only current month record (no last month data)
    Record.create!(
      player: player,
      month: current_month,
      standard_rating: 1400,
      standard_rank: 5
    )

    get ranking_differences_path, params: {
      player_search_parameter: {
        month: "#{current_month.year}-#{current_month.month}"
      }
    }
    
    assert_response :success
    assert_select '.badge.bg-info', text: 'NEW'
  end
end