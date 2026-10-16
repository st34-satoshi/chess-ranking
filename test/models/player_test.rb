# frozen_string_literal: true

require 'test_helper'

class PlayerTest < ActiveSupport::TestCase
  setup do
    @player = players(:one)
    @player.records.create!(month: '2026-01-01', standard_rating: 1800, rapid_rating: 1700, standard_rank: 20)
    @player.records.create!(month: '2026-03-01', standard_rating: 0, rapid_rating: 1750, standard_rank: 100)
    @player.records.create!(month: '2026-04-01', standard_rating: 1850, rapid_rating: 0, standard_rank: 15)
  end

  test 'rating histories share months and retain independent missing values' do
    assert_equal [202_601, 202_602, 202_603, 202_604], @player.dates
    assert_equal({
                   '202601' => { 'standard_rating' => 1800, 'rapid_rating' => 1700 },
                   '202603' => { 'standard_rating' => nil, 'rapid_rating' => 1750 },
                   '202604' => { 'standard_rating' => 1850, 'rapid_rating' => nil }
                 }, JSON.parse(@player.rating_record_objects))
    assert_equal %w[202601 202604], JSON.parse(@player.record_objects).keys
    assert_equal 1850, @player.current_rating
    assert_equal 1850, @player.best_rating
    assert_equal 15, @player.current_rank
    assert_equal 15, @player.best_rank
  end

  test 'current rapid rating does not carry forward a historical rating' do
    assert_nil @player.current_rapid_rating
    assert_equal 1750, @player.best_rapid_rating
  end

  test 'current rapid rating uses the latest month rather than insertion order' do
    @player.records.create!(month: '2025-12-01', rapid_rating: 2000)
    @player.records.create!(month: '2026-05-01', rapid_rating: 1900)
    assert_equal 1900, @player.current_rapid_rating
    assert_equal 2000, @player.best_rapid_rating
  end

  test 'unrated rapid history has no current or best rating' do
    @player.records.update_all(rapid_rating: 0)
    assert_nil @player.current_rapid_rating
    assert_nil @player.best_rapid_rating
  end

  test 'both unrated values are serialized as null' do
    @player.records.update_all(standard_rating: 0, rapid_rating: 0)
    assert(JSON.parse(@player.rating_record_objects).values.all? { |ratings| ratings.values.all?(&:nil?) })
  end
end
