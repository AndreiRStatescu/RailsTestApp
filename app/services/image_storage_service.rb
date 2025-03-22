require 'mini_magick'

class ImageStorageService
  REDIS_IMAGE_PREFIX = "account_image:"
  REDIS_VISIT_COUNT_PREFIX = "image_visits:"
  MAX_IMAGE_SIZE = 5.megabytes
  ALLOWED_CONTENT_TYPES = %w[image/jpeg image/png image/gif].freeze
  
  def self.store_image(account_id, image_file)
    # Check file size
    if image_file.size > MAX_IMAGE_SIZE
      return { success: false, error: "Image is too large. Maximum size is 5MB." }
    end
    
    # Check content type
    unless ALLOWED_CONTENT_TYPES.include?(image_file.content_type)
      return { success: false, error: "Invalid file type. Only JPEG, PNG and GIF are allowed." }
    end
    
    image = MiniMagick::Image.read(image_file)
    
    # Resize if too large (optional)
    image.resize "1024x1024>" if image.width > 1024 || image.height > 1024
    
    # Convert to binary
    binary_data = image.to_blob
    
    # Generate a unique key
    timestamp = Time.now.to_i
    image_key = "#{REDIS_IMAGE_PREFIX}#{account_id}_#{timestamp}"
    
    # Store in Redis with a 1-day expiration (for demo purposes)
    REDIS.set(image_key, binary_data)
    
    # Initialize visit count for this image to 0
    visit_count_key = get_visit_count_key_from_image_key(image_key)
    REDIS.set(visit_count_key, 0)
    
    # Return the key reference
    { success: true, key: image_key }
  end
  
  def self.get_image(image_key)
    REDIS.get(image_key)
  end
  
  def self.delete_image(image_key)
    # Delete both the image and its visit count
    visit_count_key = get_visit_count_key_from_image_key(image_key)
    
    # Use multi to delete both keys atomically
    result = REDIS.multi do |transaction|
      transaction.del(image_key)
      transaction.del(visit_count_key)
    end
    
    result && result.first == 1
  end
  
  def self.get_content_type(image_key)
    # Try to identify content type from image data
    # In a production app, you'd want to store this metadata separately
    binary_data = REDIS.get(image_key)
    return nil unless binary_data
    
    # Simple content type detection
    if binary_data.start_with?("\xFF\xD8".b)
      'image/jpeg'
    elsif binary_data.start_with?("\x89PNG\r\n\x1A\n".b)
      'image/png'
    elsif binary_data.start_with?("GIF87a".b) || binary_data.start_with?("GIF89a".b)
      'image/gif'
    else
      'application/octet-stream'
    end
  end
  
  # Get visit count for an image
  def self.get_visit_count(image_key)
    visit_count_key = get_visit_count_key_from_image_key(image_key)
    count = REDIS.get(visit_count_key)
    
    # Return 0 if no count exists (this shouldn't happen if initialized properly)
    count.nil? ? 0 : count.to_i
  end
  
  # Generate the visit count key from an image key
  def self.get_visit_count_key_from_image_key(image_key)
    # Extract the unique identifier part from the image key
    # Replace the image prefix with the visit count prefix
    image_key.sub(REDIS_IMAGE_PREFIX, REDIS_VISIT_COUNT_PREFIX)
  end
  
  # Initialize visit counts for existing images
  def self.initialize_missing_visit_counts(account)
    return unless account && account.image_keys.present?
    
    account.image_keys.each do |image_key|
      visit_count_key = get_visit_count_key_from_image_key(image_key)
      
      # Only set if the key doesn't exist yet
      REDIS.setnx(visit_count_key, 0)
    end
  end
  
  # Initialize visit counts for all accounts
  def self.initialize_all_visit_counts
    Account.find_each do |account|
      initialize_missing_visit_counts(account)
    end
  end
end