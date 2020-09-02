Gem::Specification.new do |s|
  s.name = "redis_hash_store"
  s.version = "1.0.0"
  s.authors = ["Alex Golubenko"]
  s.email = "alexandr1golubenko@gmail.com"
  s.summary = "Redis Hache Store"
  s.description = "Addition for the redis_cache_store to provide ability"\
                  "to store cache using Redis Hashes"
  s.files = Dir["lib/**/*"]
  s.homepage = "https://github.com/mrsool/redis_hash_store"
  s.require_paths = ["lib"]
  s.license = "MIT"

  s.add_development_dependency "appraisal"
  s.add_development_dependency "rake", "~> 12.3.2"
  s.add_development_dependency "rspec", "~> 3.0"

  s.add_dependency "activesupport"
  s.add_dependency "railties"
  s.add_dependency "redis"
  s.add_dependency "redis-rails"
  s.add_dependency "redis-store"
end
