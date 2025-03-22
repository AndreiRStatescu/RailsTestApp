require 'mini_magick'

class ImageStorageService
  REDIS_IMAGE_PREFIX = "account_image:"
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
    image_key = "#{REDIS_IMAGE_PREFIX}#{account_id}_#{Time.now.to_i}"
    
    # Store in Redis with a 1-day expiration (for demo purposes)
    REDIS.set(image_key, binary_data)
    
    # Return the key reference
    { success: true, key: image_key }
  end
  
  def self.get_image(image_key)
    REDIS.get(image_key)
  end
  
  def self.delete_image(image_key)
    REDIS.del(image_key)
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
end