# frozen_string_literal: true

require 'test_helper'
require 'rake'

class RapidRankTaskTest < ActiveSupport::TestCase
  self.fixture_table_names = ['players']

  setup do
    @previous_rake = Rake.application
    Rake.application = Rake::Application.new
    load Rails.root.join('lib/tasks/rapid_rank.rake')
    Rake::Task.define_task(:environment)
    Record.delete_all
    @january = Record.create!(player: players(:one), month: Date.new(2026, 1, 10), rapid_rating: 2000)
    @january_unrated = Record.create!(player: players(:two), month: Date.new(2026, 1, 31), rapid_rating: 0)
    @february = Record.create!(player: players(:one), month: Date.new(2026, 2, 5), rapid_rating: 1900)
  end

  teardown do
    Rake.application = @previous_rake
  end

  test 'all months run once in chronological order and can be repeated' do
    2.times do
      assert_output("2026-01: processed 2 records\n2026-02: processed 1 records\n") { run_task }
      assert_equal 1, @january.reload.rapid_rank
      assert_nil @january_unrated.reload.rapid_rank
      assert_equal 1, @february.reload.rapid_rank
    end
  end

  test 'specified month recalculates only that month' do
    assert_output("2026-01: processed 2 records\n") { run_task('2026-01') }
    assert_equal 1, @january.reload.rapid_rank
    assert_nil @february.reload.rapid_rank
    @january.update!(rapid_rating: 0)
    assert_output("2026-01: processed 2 records\n") { run_task('2026-01') }
    assert_nil @january.reload.rapid_rank
  end

  test 'empty month succeeds and invalid month is rejected' do
    assert_output("2026-03: processed 0 records\n") { run_task('2026-03') }
    %w[2026-13 2026-1 invalid 2026-01-01].each do |month|
      assert_raises(ArgumentError) { run_task(month) }
    end
  end

  private

  def run_task(month = nil)
    task = Rake::Task['rapid_rank:recalculate']
    task.reenable
    task.invoke(month)
  end
end
