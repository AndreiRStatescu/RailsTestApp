class Account < ApplicationRecord
  has_and_belongs_to_many :users

  validates :name, presence: true

  # Initialize urls and image_keys as empty arrays
  attribute :urls, :json, default: []
  attribute :image_keys, :json, default: []

  # Maximum number of images per account
  MAX_IMAGES = 10

  # Validate that each URL is valid
  validate :validate_urls
  validate :validate_image_keys_limit

  # Add an image key to the image_keys array
  def add_image_key(key)
    # Initialize as empty array if it's nil
    self.image_keys ||= []
    # Add the new key
    self.image_keys << key
    # Save the record
    self.save
  end

  # Remove an image key from the image_keys array
  def remove_image_key(key)
    return false unless image_keys.present?

    # Remove the key
    self.image_keys = self.image_keys.reject { |k| k == key }
    # Save the record
    self.save
  end

  # Check if the account has reached the maximum number of images
  def max_images_reached?
    image_keys.present? && image_keys.size >= MAX_IMAGES
  end

  private

  def validate_urls
    return unless urls.is_a?(Array)

    urls.each do |url|
      unless url =~ URI::DEFAULT_PARSER.make_regexp(%w[http https])
        errors.add(:urls, "contains an invalid URL: #{url}")
      end
    end
  end

  def validate_image_keys_limit
    return unless image_keys.is_a?(Array)

    if image_keys.size > MAX_IMAGES
      errors.add(:image_keys, "cannot exceed #{MAX_IMAGES} images per account")
    end
  end
end
