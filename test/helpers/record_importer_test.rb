# frozen_string_literal: true

require 'test_helper'
require 'minitest/mock'
require 'csv'

class RecordImporterTest < ActiveSupport::TestCase
  test 'new imports calculate rapid ranks alongside unchanged standard ranks and skip existing months' do
    import_fixture
    records = Record.where(month: Date.new(2026, 3, 15)).order(:id)
    assert_equal [2, 1, 2, nil, 4], records.pluck(:rapid_rank)
    assert_equal [1, 2, 5, 3, 4], records.pluck(:standard_rank)
    assert_no_difference('Record.count') { import_fixture }
  end

  test 'rapid rank failure rolls back imported players and records' do
    failure = ->(_date) { raise 'rapid rank failed' }
    assert_no_difference(['Player.count', 'Record.count']) do
      Record.stub(:add_rapid_rank, failure) do
        assert_raises(RuntimeError) { import_fixture }
      end
    end
  end

  private

  def import_fixture
    path = Rails.root.join('test/fixtures/files/rating-2026-03-15.csv')
    original_foreach = CSV.method(:foreach)
    read_fixture = ->(_path, &block) { original_foreach.call(path, &block) }
    CSV.stub(:foreach, read_fixture) { RecordImporter.create_record('rating-2026-03-15.csv') }
  end
end
