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
  
  test "image_keys should default to empty array" do
    account = Account.new(name: "Test Account", description: "Test description")
    assert_equal [], account.image_keys
  end
  
  test "add_image_key should add key to image_keys" do
    account = Account.new(name: "Test Account", description: "Test description")
    account.save!
    
    assert_equal 0, account.image_keys.size
    account.add_image_key("test_key_1")
    assert_equal 1, account.image_keys.size
    assert_includes account.image_keys, "test_key_1"
  end
  
  test "remove_image_key should remove key from image_keys" do
    account = Account.new(name: "Test Account", description: "Test description")
    account.save!
    
    account.add_image_key("test_key_1")
    account.add_image_key("test_key_2")
    assert_equal 2, account.image_keys.size
    
    account.remove_image_key("test_key_1")
    assert_equal 1, account.image_keys.size
    assert_not_includes account.image_keys, "test_key_1"
    assert_includes account.image_keys, "test_key_2"
  end
  
  test "max_images_reached? should return true when at limit" do
    account = Account.new(name: "Test Account", description: "Test description")
    account.save!
    
    # Add the maximum number of images
    Account::MAX_IMAGES.times do |i|
      account.add_image_key("test_key_#{i}")
    end
    
    assert account.max_images_reached?
  end
  
  test "max_images_reached? should return false when below limit" do
    account = Account.new(name: "Test Account", description: "Test description")
    account.save!
    
    # Add one less than the max
    (Account::MAX_IMAGES - 1).times do |i|
      account.add_image_key("test_key_#{i}")
    end
    
    assert_not account.max_images_reached?
  end
  
  test "should not save account with too many image keys" do
    account = Account.new(name: "Test Account", description: "Test description")
    
    # Set more than the maximum allowed
    keys = (0..Account::MAX_IMAGES).map { |i| "test_key_#{i}" }
    account.image_keys = keys
    
    assert_not account.save
    assert_includes account.errors[:image_keys], "cannot exceed #{Account::MAX_IMAGES} images per account"
  end
end
