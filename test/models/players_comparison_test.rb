# frozen_string_literal: true

require 'test_helper'

class PlayersComparisonTest < ActiveSupport::TestCase
  test 'result URL is optional unless the URL tab is selected' do
    comparison = PlayersComparison.new
    assert comparison.valid?

    comparison.contain_result_url = 'true'
    assert_not comparison.valid?
    assert comparison.errors.of_kind?(:result_url, :blank)
  end

  test 'only supported chess results URLs are accepted' do
    %w[https://chess-results.com/tnr123.aspx https://chess-results.com/Tnr123.aspx].each do |url|
      assert PlayersComparison.new(result_url: url).valid?
    end

    %w[https://example.com/tnr123.aspx https://chess-results.com.example.com/tnr123.aspx].each do |url|
      comparison = PlayersComparison.new(result_url: url)
      assert_not comparison.valid?
      assert comparison.errors.of_kind?(:result_url, :invalid)
    end
  end
end
