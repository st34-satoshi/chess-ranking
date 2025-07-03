require 'test_helper'

class RankingDiffsControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get ranking_diffs_path
    assert_response :success
  end
end
