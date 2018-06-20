require 'test_helper'

class CheckoutItemsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get checkout_items_create_url
    assert_response :success
  end

  test "should get update" do
    get checkout_items_update_url
    assert_response :success
  end

  test "should get destroy" do
    get checkout_items_destroy_url
    assert_response :success
  end

end
