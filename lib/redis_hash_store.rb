# frozen_string_literal: true

require "active_support"
require "redis"
require "redis-activesupport"

require "active_support/cache/redis_hash_store"

module RedisHashStore
  mattr_accessor :logger, :cache
end
