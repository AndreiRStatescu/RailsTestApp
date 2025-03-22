class Account < ApplicationRecord
  has_and_belongs_to_many :users
  
  validates :name, presence: true
  
  # Initialize urls as an empty array
  attribute :urls, :json, default: []
  
  # Validate that each URL is valid
  validate :validate_urls
  
  private
  
  def validate_urls
    return unless urls.is_a?(Array)
    
    urls.each do |url|
      unless url =~ URI::DEFAULT_PARSER.make_regexp(%w[http https])
        errors.add(:urls, "contains an invalid URL: #{url}")
      end
    end
  end
end
