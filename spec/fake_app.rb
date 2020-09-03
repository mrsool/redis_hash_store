# frozen_string_literal: true

require 'redis_hash_store'
require 'rails'

# The Dummy class is responsible for imitate rails app for tests
module Dummy
  class Application < Rails::Application
    config.eager_load = false

    config.cache_store = :redis_hash_store, { host: "127.0.0.1", port: "6379" }
  end
end

Rails.logger = Logger.new("/dev/null")

Rails.application.initialize!
