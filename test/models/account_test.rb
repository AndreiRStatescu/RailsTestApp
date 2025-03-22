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
  
  test "should save account with valid URLs" do
    account = Account.new(
      name: "Test Account", 
      description: "Test description", 
      urls: ["https://example.com", "https://test.org"]
    )
    assert account.save, "Could not save account with valid URLs"
  end
  
  test "should not save account with invalid URLs" do
    account = Account.new(
      name: "Test Account", 
      description: "Test description", 
      urls: ["not-a-url", "https://valid.com"]
    )
    assert_not account.save, "Saved account with invalid URLs"
    assert_includes account.errors[:urls].first, "not-a-url"
  end
  
  test "urls should default to empty array" do
    account = Account.new(name: "Test Account", description: "Test description")
    assert_equal [], account.urls
  end
end
