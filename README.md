# RedisHashStore
`RedisHashStore` is addition to `ActiveSupport::Cache::RedisCacheStore`.

The main idea of this gem is to expand functionality of `RedisCacheStore` by adding abillity to use Redis Hashes as cache-store.

## Rails
Supported Rails versions are listed in `Appraisals`. 
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

* `#write_hash_value`
* `#read_hash_value`
* `#fetch_hash_value`
* `#read_hash`
* `#delete_hash_value`
* `#delete_hash`

### Examples

```ruby
Rails.cache.write_hash_value('foo', 'boo', 'baz')
=> 1
Rails.cache.write_hash_value('foo', 'baz', 'boo')
=> 1
```

Now it's accessible by:

```ruby
Rails.cache.read_hash_value('foo', 'boo')
=> 'baz'
Rails.cache.read_hash_value('foo', 'baz')
=> 'boo'
```

Looks pretty easy, right? Maybe you're thinking: "What the difference?"


1. You can access all records under the `foo` hash
```ruby
Rails.cache.read_hash('foo')
=> { "baz"=>"boo", "boo"=>"baz" }
```
2. You can easily remove every value under `foo`
```ruby
Rails.cache.delete_hash_value('foo', 'baz')
=> 1
```
3. You can also delete the entire `foo` hash
```ruby
Rails.cache.delete_hash('foo')
=> 1
```

What about `#fetch`?
Here you go:
```ruby
Rails.cache.fetch_hash_value('foo', 'boo') { 'bar' }
=> 'bar'
Rails.cache.fetch_hash_value('foo', 'boo') { 'baz' }
=> 'bar'
Rails.cache.fetch_hash_value('foo', 'boo', force: true) { 'baz' }
=> 'baz'
```

## Idea
We decided to create this gem because:

 1. We were previously using [`#delete_matched`](https://apidock.com/rails/ActiveSupport/Cache/Store/delete_matched) which can have many performance issues at scale (See this [similar issue at GitLab]((https://gitlab.com/gitlab-org/gitlab/-/issues/201808)).
2. `#deleted_matched` doesn't delete values from all the nodes in a Redis cluster.

### Benchmarks:
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
