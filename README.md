# RedisHashStore
![](https://img.shields.io/gem/v/redis_hash_store)

`RedisHashStore` extends ActiveSupport's [`RedisCacheStore`](https://github.com/rails/rails/blob/master/activesupport/lib/active_support/cache/redis_cache_store.rb) to provide the ability to easily use Redis hashes for caching.

We decided to create this gem because:

1. We were previously using [`#delete_matched`](https://apidock.com/rails/ActiveSupport/Cache/Store/delete_matched) which can have many performance issues at scale (See this [similar issue at GitLab](https://gitlab.com/gitlab-org/gitlab/-/issues/201808)).
2. `#deleted_matched` doesn't delete values from all the nodes in a Redis cluster.

## Rails
Supported Rails versions are listed in [`Appraisals`](https://github.com/mrsool/redis_hash_store/blob/master/Appraisals). 

## Installing
Install it yourself as:
```bash
$ gem install redis_hash_store
```
Or add it to your `Gemfile`:
```ruby
gem 'redis_hash_store'
```
and then execute:
```bash
$ bundle
```

## Configuration
All you need to do is add:
```ruby
# config/production(development|test|staging|preview).rb

config.cache_store = :redis_hash_store, redis_cache_store_options
```

## Usage
This gem simply adds new functionality to `RedisCacheStore`, so all existing logic in that class is not affected.

Here is a list of available methods:

* [`#write_hash_value`](#write_hash_value)
* [`#read_hash_value`](#read_hash_value)
* [`#read_hash`](#read_hash)
* [`#delete_hash_value`](#delete_hash_value)
* [`#delete_hash`](#delete_hash)
* [`#fetch_hash_value`](#fetch_hash_value)

## Examples

> Let's imagine we need to store amount of Services for City.

#### #write_hash_value

```ruby
city = "Riyadh"
coffee_shop_type = "coffee_shop"
restaurants_type = "restaurant"

coffee_shops_count = Service.where(type: coffee_shop_type, city: city).count
=> 250
restaurants_count = Service.where(type: restaurants_type, city: city).count
=> 340

Rails.cache.write_hash_value("#{city} counters", coffee_shop_type, coffee_shops_count)
=> 1
Rails.cache.write_hash_value("#{city} counters", restaurants_type, restaurants_count)
=> 1
```
#### #read_hash_value

Now it's accessible by:

```ruby
Rails.cache.read_hash_value("#{city} counters", coffee_shop_type)
=> 250
Rails.cache.read_hash_value("#{city} counters", restaurants_type)
=> 340
```
#### #read_hash

Looks pretty easy, right? Maybe you're thinking: "What the difference?"

1. You can access all records under the `"#{city} counters"` hash
```ruby
Rails.cache.read_hash("#{city} counters")
=> { "coffee_shop"=>250, "restaurant"=>340 }
```

#### #delete_hash_value

2. You can easily remove every value under `"#{city} counters"`
```ruby
Rails.cache.delete_hash_value("#{city} counters", coffee_shop_type)
=> 1
```

#### #delete_hash

3. You can also delete the entire `"#{city} counters"` hash
```ruby
Rails.cache.delete_hash("#{city} counters")
=> 1
```
#### #fetch_hash_value
4. You can fetch needed value under `"#{city} counters"`
```ruby
Rails.cache.fetch_hash_value("#{city} counters", coffee_shop_type) do
  Service.where(type: coffee_shop_type, city: city).count
end
=> 250

Rails.cache.fetch_hash_value("#{city} counters", coffee_shop_type, force: true) do
  Service.where(type: coffee_shop_type, city: city).count * 2
end
=> 500
```

## Benchmarks
```ruby
indexes = 1..1_000_000

indexes.each do |index|
  Rails.cache.write("some_data_#{index}", index)
  Rails.cache.write_hash_value("some_data", index, index)
end

Benchmark.bm do |x|
  x.report("delete_matched")  { Rails.cache.delete_matched("some_data_*") }
  x.report("delete_hash")     { Rails.cache.delete_hash("some_data") }
end

    user         system      total        real
delete_matched  0.571040   0.244962   0.816002 (3.791056)
delete_hash     0.000000   0.000225   0.000225 (0.677891)
```

## Contributing
Please see [CONTRIBUTING.md](https://github.com/mrsool/redis_hash_store/blob/master/CONTRIBUTING.md).
