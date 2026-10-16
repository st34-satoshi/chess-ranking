# frozen_string_literal: true

require 'application_system_test_case'

class PlayerRanksTest < ApplicationSystemTestCase
  setup do
    @player = players(:one)
    @player.update!(name_en: 'Test Player', name_jp: 'テスト選手')
    [[1, 1800, 1700], [3, 0, 1750], [4, 1850, 0], [5, 1900, 1800]].each do |month, standard, rapid|
      @player.records.create!(month: Date.new(2026, month, 1), standard_rating: standard,
                              rapid_rating: rapid, standard_rank: 20, rapid_rank: 30)
    end
  end

  test 'both series use independent gaps and the legend toggles visibility' do
    visit player_path(@player, locale: :ja)
    assert_selector '#rankChart'
    assert_equal %w[スタンダード ラピッド], rank_chart_value('data.datasets.map(d => d.label)')
    assert_equal [[20, nil, nil, 20, 20], [30, nil, 30, nil, 30]], rank_chart_value('data.datasets.map(d => d.data)')
    assert_equal [true, true], rank_chart_value('data.datasets.map(d => d.spanGaps)')
    assert_equal [6, 6], rank_chart_value('data.datasets[0].segment.borderDash({p0: {skip: true}, p1: {skip: false}})')
    assert_nil rank_chart_value('data.datasets[1].segment.borderDash({p0: {skip: false}, p1: {skip: false}})')
    assert_equal true, rank_chart_value('options.scales.y.reverse')
    assert_equal 1, rank_chart_value('options.scales.y.min')
    click_rapid_legend
    assert_rapid_visibility(false)
    assert_equal true, rank_chart_value('isDatasetVisible(0)')
    click_rapid_legend
    assert_rapid_visibility(true)
  end

  test 'single series and unrated history work in English on mobile' do
    page.current_window.resize_to(390, 844)
    @player.records.update_all(standard_rating: 0)
    visit player_path(@player, locale: :en)
    assert_text 'Standard rank'
    assert_equal %w[Standard Rapid], rank_chart_value('data.datasets.map(d => d.label)')
    assert_equal [nil] * 5, rank_chart_value('data.datasets[0].data')
    assert_equal [30, nil, 30, nil, 30], rank_chart_value('data.datasets[1].data')
    assert page.evaluate_script('document.getElementById("rankChart").getBoundingClientRect().right <= window.innerWidth')

    @player.records.update_all(standard_rating: 1800, rapid_rating: 0)
    visit player_path(@player, locale: :en)
    assert_equal [20, nil, 20, 20, 20], rank_chart_value('data.datasets[0].data')
    assert_equal [nil] * 5, rank_chart_value('data.datasets[1].data')

    @player.records.update_all(standard_rating: 0)
    visit player_path(@player, locale: :en)
    assert_text 'No rank data available.'
    assert_text 'Current: Unrated / Best: Unrated'
    assert_no_selector '#rankChart'
  ensure
    page.current_window.resize_to(1400, 1400)
  end

  test 'uncomputed ranks show the empty state even when ratings exist' do
    @player.records.update_all(standard_rank: nil, rapid_rank: nil)
    visit player_path(@player, locale: :ja)
    assert_text '順位データはありません。'
    assert_no_selector '#rankChart'
    assert_selector '#ratingChart'
  end

  private

  def assert_rapid_visibility(expected)
    Timeout.timeout(Capybara.default_max_wait_time) do
      sleep 0.05 until rank_chart_value('isDatasetVisible(1)') == expected
    end
    assert_equal expected, rank_chart_value('isDatasetVisible(1)')
  end

  def click_rapid_legend
    page.execute_script('document.getElementById("rankChart").scrollIntoView({block: "center", behavior: "instant"})')
    point = page.evaluate_script(<<~JS)
      (() => {
        const chart = Chart.getChart('rankChart');
        const rect = chart.canvas.getBoundingClientRect();
        const box = chart.legend.legendHitBoxes[1];
        return [Math.round(rect.left + box.left + box.width / 2), Math.round(rect.top + box.top + box.height / 2)];
      })()
    JS
    page.driver.browser.action.move_to_location(*point).click.perform
  end

  def rank_chart_value(expression)
    assert_selector '#rankChart'
    Timeout.timeout(Capybara.default_max_wait_time) do
      sleep 0.05 until page.evaluate_script('!!window.Chart && !!Chart.getChart("rankChart")')
    end
    page.evaluate_script("Chart.getChart('rankChart').#{expression}")
  end
end
