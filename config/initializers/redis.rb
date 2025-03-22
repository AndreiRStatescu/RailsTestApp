require 'redis'

# Create a dummy Redis implementation for development/testing if Redis is not available
class DummyRedis
  def initialize
    @storage = {}
  end
  
  def set(key, value)
    @storage[key] = value
  end
  
  def get(key)
    @storage[key]
  end
  
  def del(key)
    @storage.delete(key)
  end
  
  def ping
    "PONG"
  end
end

begin
  # Set up Redis connection
  redis = Redis.new(url: ENV["REDIS_URL"] || "redis://localhost:6379/0")
  
  # Test connection
  redis.ping
  
  Rails.logger.info "Connected to Redis successfully"
  REDIS = redis
rescue Redis::CannotConnectError => e
  Rails.logger.error "Failed to connect to Redis: #{e.message}"
  
  # Use dummy implementation for development/testing
  if Rails.env.development? || Rails.env.test?
    Rails.logger.warn "Using dummy Redis implementation for development/testing"
    REDIS = DummyRedis.new
  else
    raise e
  end
end