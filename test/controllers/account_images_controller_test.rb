require "test_helper"

class AccountImagesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  
  setup do
    @account = accounts(:one)
    @user = users(:one)
    sign_in @user
  end
  
  test "should get index" do
    get account_images_url(@account)
    assert_response :success
  end

  test "should get upload form" do
    get upload_account_images_url(@account)
    assert_response :success
  end
  
  test "should handle missing image file" do
    post account_images_url(@account), params: {}
    assert_redirected_to upload_account_images_path(@account)
    assert_not_nil flash[:alert]
  end
end
