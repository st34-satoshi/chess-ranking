# frozen_string_literal: true

require 'test_helper'

class RecordTest < ActiveSupport::TestCase
  self.fixture_table_names = ['players']

  test 'rapid ranks use competition ranking without changing standard ranks' do
    records = [1900, 0, 2000, 1900, 1800].map { |rating| create_record(rating) }
    assert_nil records.first.rapid_rank

    assert_equal 5, Record.add_rapid_rank(Date.new(2026, 1, 15))
    assert_equal([2, nil, 1, 2, 4], records.map { |record| record.reload.rapid_rank })
    assert_equal [42] * 5, records.map(&:standard_rank)
  end

  test 'all tied records rank first including inactive nonmembers with no standard rating' do
    records = Array.new(3) { create_record(1500) }
    Record.add_rapid_rank(Date.new(2026, 1, 1))
    assert_equal([1, 1, 1], records.map { |record| record.reload.rapid_rank })
  end

  test 'months and years are independent and include dates other than the first' do
    records = [Date.new(2026, 1, 1), Date.new(2026, 1, 31), Date.new(2026, 2, 1), Date.new(2025, 1, 1)].map do |date|
      create_record(1500, month: date)
    end
    Record.add_rapid_rank(Date.new(2026, 1, 20))
    assert_equal([1, 1, nil, nil], records.map { |record| record.reload.rapid_rank })
  end

  test 'recalculation uses the entire month and clears obsolete ranks' do
    records = [2000, 1900, 1800].map { |rating| create_record(rating) }
    2.times do
      Record.add_rapid_rank(Date.new(2026, 1, 1))
      assert_equal([1, 2, 3], records.map { |record| record.reload.rapid_rank })
    end
    records[0].update!(rapid_rating: 0)
    records[2].update!(rapid_rating: 2100, rapid_rank: nil)
    Record.add_rapid_rank(Date.new(2026, 1, 1))
    assert_equal([nil, 2, 1], records.map { |record| record.reload.rapid_rank })
  end

  test 'empty and entirely unrated months succeed without carrying ratings forward' do
    create_record(2000, month: Date.new(2025, 12, 1))
    record = create_record(0, rapid_rank: 1)
    assert_equal 1, Record.add_rapid_rank(Date.new(2026, 1, 1))
    assert_nil record.reload.rapid_rank
    assert_equal 0, Record.add_rapid_rank(Date.new(2026, 2, 1))
  end

  test 'failed updates roll back the entire month' do
    records = [2000, 1900].map { |rating| create_record(rating) }
    failure = proc { raise 'rank update failed' if rapid_rating == 1900 }
    Record.set_callback(:update, :before, failure)
    assert_raises(RuntimeError) { Record.add_rapid_rank(Date.new(2026, 1, 1)) }
    assert_equal([nil, nil], records.map { |record| record.reload.rapid_rank })
  ensure
    Record.skip_callback(:update, :before, failure)
  end

  private

  def create_record(rating, **attributes)
    Record.create!({ player: players(:one), month: Date.new(2026, 1, 10), rapid_rating: rating,
                     standard_rating: 0, standard_rank: 42, member: nil, active: nil }.merge(attributes))
  end
end
