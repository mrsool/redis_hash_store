# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name = "redis_hash_store"
  s.version = "1.0.0"
  s.authors = ["Alex Golubenko", "Omar Bahareth"]
  s.email = "sub@mrsool.co"
  s.summary = "Redis Hash Store"
  s.description = "An addition to Rails's redis_cache_store to allow you"\
                  "to easily use Redis hashes for caching"
  s.files = Dir["lib/**/*"]
  s.homepage = "https://github.com/mrsool/redis_hash_store"
  s.require_paths = ["lib"]
  s.license = "MIT"

  s.add_development_dependency("appraisal")
  s.add_development_dependency("rake", "~> 12.3.2")
  s.add_development_dependency("rspec", "~> 3.0")
  s.add_development_dependency("rubocop")
  s.add_development_dependency("rubocop-performance")
  s.add_development_dependency("rubocop-rails")
  s.add_development_dependency("rubocop-rspec")

  s.add_dependency("activesupport")
  s.add_dependency("railties")
  s.add_dependency("redis")
  s.add_dependency("redis-rails")
  s.add_dependency("redis-store")
end
