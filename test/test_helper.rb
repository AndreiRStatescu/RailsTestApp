ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "mocha/minitest"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
    
    # Create a test image file for uploads
    def setup_test_image
      file_path = Rails.root.join('test', 'fixtures', 'files', 'test.jpg')
      unless File.exist?(file_path)
        FileUtils.mkdir_p(File.dirname(file_path))
        File.write(file_path, "test image data")
      end
    end
  end
end
