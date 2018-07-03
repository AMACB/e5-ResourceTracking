require 'test_helper'

class CheckoutsControllerTest < ActionDispatch::IntegrationTest
  test "should show" do
    get cart_url
    assert_response :success
  end

end
