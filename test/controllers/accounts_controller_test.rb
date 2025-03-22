require "test_helper"

class AccountsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  
  setup do
    @account = accounts(:one)
    @user = users(:one)
    sign_in @user
  end
  
  test "should get index" do
    get accounts_url
    assert_response :success
  end

  test "should join account" do
    assert_difference('@user.accounts.count', 1) do
      post join_account_url(@account)
    end
    assert_redirected_to accounts_url
  end

  test "should leave account" do
    @user.accounts << @account
    assert_difference('@user.accounts.count', -1) do
      delete leave_account_url(@account)
    end
    assert_redirected_to accounts_url
  end
end
