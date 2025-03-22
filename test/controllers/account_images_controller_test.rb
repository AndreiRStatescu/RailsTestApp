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
  
  test "should redirect when maximum images reached" do
    # Update account to have max images
    @account.image_keys = (1..Account::MAX_IMAGES).map { |i| "test_key_#{i}" }
    @account.save!
    
    get upload_account_images_url(@account)
    assert_redirected_to account_images_path(@account)
    assert_match /Maximum number of images/, flash[:alert]
  end
  
  test "should not allow uploading when maximum images reached" do
    # Update account to have max images
    @account.image_keys = (1..Account::MAX_IMAGES).map { |i| "test_key_#{i}" }
    @account.save!
    
    post account_images_url(@account), params: { image: fixture_file_upload('test.jpg', 'image/jpeg') }
    assert_redirected_to account_images_path(@account)
    assert_match /Maximum number of images/, flash[:alert]
  end
  
  test "should handle image deletion" do
    # Add a test image key
    test_key = "test_key_123"
    @account.add_image_key(test_key)
    
    # Mock the ImageStorageService
    ImageStorageService.expects(:delete_image).with(test_key).returns(true)
    
    delete account_image_url(@account, test_key)
    assert_redirected_to account_images_path(@account)
    assert_not_includes @account.reload.image_keys, test_key
  end
  
  test "should handle invalid image key deletion" do
    invalid_key = "nonexistent_key"
    
    delete account_image_url(@account, invalid_key)
    assert_redirected_to account_images_path(@account)
    assert_match /Image not found or doesn't belong to this account/, flash[:alert]
  end
end
