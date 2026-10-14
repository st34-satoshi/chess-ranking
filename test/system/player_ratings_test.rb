# frozen_string_literal: true

require 'application_system_test_case'

class PlayerRatingsTest < ApplicationSystemTestCase
  setup do
    @player = players(:one)
    @player.update!(name_en: 'Test Player', name_jp: 'テスト選手')
    [[1, 1800, 1700], [3, 0, 1750], [4, 1850, 0], [5, 1900, 1800]].each do |month, standard, rapid|
      @player.records.create!(month: Date.new(2026, month, 1), standard_rating: standard,
                              rapid_rating: rapid, standard_rank: 20)
    end
  end

  test 'both series use independent gaps and the legend toggles visibility' do
    visit player_path(@player, locale: :ja)
    assert_selector '#ratingChart'
    assert_equal %w[スタンダード ラピッド], chart_value('data.datasets.map(d => d.label)')
    assert_equal [[1800, nil, nil, 1850, 1900], [1700, nil, 1750, nil, 1800]], chart_value('data.datasets.map(d => d.data)')
    assert_equal [true, true], chart_value('data.datasets.map(d => d.spanGaps)')
    assert_equal [6, 6], chart_value('data.datasets[0].segment.borderDash({p0: {skip: true}, p1: {skip: false}})')
    assert_nil chart_value('data.datasets[1].segment.borderDash({p0: {skip: false}, p1: {skip: false}})')
    click_rapid_legend
    assert_rapid_visibility(false)
    assert_equal true, chart_value('isDatasetVisible(0)')
    click_rapid_legend
    assert_rapid_visibility(true)
  end

  test 'single series and unrated history work in English on mobile' do
    page.current_window.resize_to(390, 844)
    @player.records.update_all(standard_rating: 0)
    visit player_path(@player, locale: :en)
    assert_text 'Standard rank'
    assert_equal %w[Standard Rapid], chart_value('data.datasets.map(d => d.label)')
    assert_equal [nil] * 5, chart_value('data.datasets[0].data')
    assert_equal [1700, nil, 1750, nil, 1800], chart_value('data.datasets[1].data')
    assert page.evaluate_script('document.getElementById("ratingChart").getBoundingClientRect().right <= window.innerWidth')

    @player.records.update_all(standard_rating: 1800, rapid_rating: 0)
    visit player_path(@player, locale: :en)
    assert_equal [1800, nil, 1800, 1800, 1800], chart_value('data.datasets[0].data')
    assert_equal [nil] * 5, chart_value('data.datasets[1].data')

    @player.records.update_all(standard_rating: 0)
    visit player_path(@player, locale: :en)
    assert_text 'No rating data available.'
    assert_text 'Current: Unrated / Best: Unrated'
    assert_no_selector '#ratingChart'
  ensure
    page.current_window.resize_to(1400, 1400)
  end

  private

  def assert_rapid_visibility(expected)
    Timeout.timeout(Capybara.default_max_wait_time) do
      sleep 0.05 until chart_value('isDatasetVisible(1)') == expected
    end
    assert_equal expected, chart_value('isDatasetVisible(1)')
  end

  def click_rapid_legend
    page.execute_script('document.getElementById("ratingChart").scrollIntoView({block: "center", behavior: "instant"})')
    point = page.evaluate_script(<<~JS)
      (() => {
        const chart = Chart.getChart('ratingChart');
        const rect = chart.canvas.getBoundingClientRect();
        const box = chart.legend.legendHitBoxes[1];
        return [Math.round(rect.left + box.left + box.width / 2), Math.round(rect.top + box.top + box.height / 2)];
      })()
    JS
    page.driver.browser.action.move_to_location(*point).click.perform
  end

  def chart_value(expression)
    assert_selector '#ratingChart'
    Timeout.timeout(Capybara.default_max_wait_time) do
      sleep 0.05 until page.evaluate_script('!!window.Chart && !!Chart.getChart("ratingChart")')
    end
    page.evaluate_script("Chart.getChart('ratingChart').#{expression}")
  end
end
