# frozen_string_literal: true

require 'test_helper'

class PlayersControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get players_path
    assert_response :success
  end
  test 'show displays current and best rapid ranks in both locales' do
    player = players(:one)
    player.update!(name_en: 'Test Player', name_jp: 'テスト選手')
    player.records.create!(month: '2026-01-01', rapid_rating: 1700, rapid_rank: 25)
    latest = player.records.create!(month: '2026-02-01', rapid_rating: 1750, rapid_rank: 30)

    %i[ja en].each do |locale|
      [30, nil].each do |rank|
        latest.update!(rapid_rank: rank)
        get player_path(player, locale: locale)
        assert_response :success
        assert_select 'h2', text: I18n.t('views.players.show.rapid_rank', locale: locale) do |headings|
          assert_equal "#{I18n.t('views.players.show.current', locale: locale)}: #{rank || '—'} / " \
                       "#{I18n.t('views.players.show.best', locale: locale)}: 25", headings.first.next_element.text
        end
      end
    end
  end

  test 'show supplies rating and rank data for both series in both locales' do
    player = players(:one)
    player.update!(name_en: 'Test Player', name_jp: 'テスト選手')
    player.records.create!(month: '2026-01-01', standard_rating: 1800, rapid_rating: 1700, standard_rank: 20)
    player.records.create!(month: '2026-03-01', standard_rating: 0, rapid_rating: 1750, standard_rank: 100)
    player.records.create!(month: '2026-04-01', standard_rating: 1850, rapid_rating: 0, standard_rank: 15)

    %i[ja en].each do |locale|
      get player_path(player, locale: locale)
      assert_response :success
      assert_select '#ratingChart' do |elements|
        chart = elements.first
        assert_equal JSON.parse(player.rating_record_objects), JSON.parse(chart['data-record'])
        assert_equal player.dates, JSON.parse(chart['data-date'])
        assert_equal I18n.t('views.players.show.rapid', locale: locale), chart['data-rapid-label']
      end
      assert_select '#rankChart' do |elements|
        assert_equal JSON.parse(player.rank_record_objects), JSON.parse(elements.first['data-record'])
        assert_equal I18n.t('views.players.show.standard', locale: locale), elements.first['data-standard-label']
        assert_equal I18n.t('views.players.show.rapid', locale: locale), elements.first['data-rapid-label']
      end
      assert_select 'p', text: /#{I18n.t('views.players.show.unrated', locale: locale)}.*1750/
      assert_select '#ratingNoData', text: I18n.t('views.players.show.no_rating_data', locale: locale)
    end
  end
end
