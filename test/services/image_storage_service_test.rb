require "test_helper"

class ImageStorageServiceTest < ActiveSupport::TestCase
  test "get_visit_count_key_from_image_key generates correct key" do
    image_key = "#{ImageStorageService::REDIS_IMAGE_PREFIX}test_123"
    expected_visit_key = "#{ImageStorageService::REDIS_VISIT_COUNT_PREFIX}test_123"
    
    result = ImageStorageService.get_visit_count_key_from_image_key(image_key)
    assert_equal expected_visit_key, result
  end
end