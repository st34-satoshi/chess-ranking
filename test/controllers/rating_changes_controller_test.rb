require "test_helper"

class RatingChangesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get rating_changes_path
    assert_response :success
  end
end
