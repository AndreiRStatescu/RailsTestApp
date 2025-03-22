require "test_helper"

class AccountTest < ActiveSupport::TestCase
  test "should not save account without name" do
    account = Account.new(description: "Test description")
    assert_not account.save, "Saved the account without a name"
  end

  test "should save valid account" do
    account = Account.new(name: "Test Account", description: "Test description")
    assert account.save, "Could not save account with valid attributes"
  end
end
