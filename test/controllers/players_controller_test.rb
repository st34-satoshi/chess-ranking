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

  test 'rapid ranks and rating changes use rapid values' do
    player = Player.create!(name_en: 'Rapid Leader', ncs_id: 'N99000001')
    other = Player.create!(name_en: 'Standard Leader', ncs_id: 'N99000002')
    Record.create!(player: player, month: Date.new(2026, 8, 1), standard_rating: 1000,
                   rapid_rating: 2100, standard_rank: 2, rapid_rank: 2)
    Record.create!(player: player, month: Date.new(2026, 9, 1), standard_rating: 1100,
                   rapid_rating: 2300, standard_rank: 2, rapid_rank: 1)
    Record.create!(player: other, month: Date.new(2026, 9, 1), standard_rating: 2500,
                   rapid_rating: 1800, standard_rank: 1, rapid_rank: 2)

    get rapid_path, params: { player_search_parameter: { month: '2026-9' } }
    assert_response :success
    assert_select 'tbody tr:first-child' do
      assert_select 'td:nth-child(1)', text: /1.*↑1/m
      assert_select 'td:nth-child(2)', text: 'Rapid Leader'
      assert_select 'td:nth-child(3)', text: /2300.*↑200/m
    end
    assert_select 'option[value=rapid][selected]'

    get rapid_path, params: { player_search_parameter: { month: '2026-9', rating_lower: 2200 } }
    assert_select 'tbody tr', count: 1

    get players_path, params: { player_search_parameter: { month: '2026-9' } }
    assert_select 'tbody tr:first-child td:nth-child(2)', text: 'Standard Leader'
  end

  test 'switching rating type preserves search and locale' do
    get players_path, params: { locale: 'en', player_search_parameter: { rating_type: 'rapid', month: '2026-8', name: 'Test' } }
    assert_response :redirect
    assert_equal '/rapid', URI.parse(response.location).path
    follow_redirect!
    assert_response :success
    assert_select 'input[name="player_search_parameter[name]"][value=Test]'
    assert_select 'input[name=locale][value=en]'
    assert_select 'h1', text: /Chess Rapid Rating Ranking in Japan/

    get rapid_path, params: { player_search_parameter: { rating_type: 'standard' } }
    assert_equal '/players', URI.parse(response.location).path
    follow_redirect!
    assert_response :success
  end

  test 'rapid records without ranks render without errors' do
    player = Player.create!(name_en: 'Unrated', ncs_id: 'N99000003')
    [8, 9].each do |month|
      Record.create!(player: player, month: Date.new(2026, month, 1), standard_rating: 1000, rapid_rating: 0)
    end
    get rapid_path, params: { player_search_parameter: { month: '2026-9' } }
    assert_response :success
    assert_select 'tbody tr:first-child td:first-child', text: ''
  end
  test 'pagination and language links retain the ranking type' do
    player = Player.create!(name_en: 'Paged Player', ncs_id: 'N99000004')
    51.times do
      Record.create!(player: player, month: Date.new(2026, 9, 1), standard_rating: 1000,
                     rapid_rating: 1500, standard_rank: 1, rapid_rank: 1)
    end
    [players_path, rapid_path].each do |path|
      get path
      assert_response :success
      page_link = css_select('.pagination a').find { |link| link.text == '2' }
      assert_equal URI.parse(path).path, URI.parse(page_link['href']).path
      get page_link['href']
      assert_response :success
      assert_select 'tbody tr', count: 1
    end
  end
end
