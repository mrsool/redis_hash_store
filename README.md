# RedisHashStore
`RedisHashStore` is addition to `ActiveSupport::Cache::RedisCacheStore`.

The main idea of this gem is to expand functionality of `RedisCacheStore` by adding abillity to use Redis Hashes as cache-store.

## Rails
Supported Rails versions are listed in `Appraisals`. 
## Instaling
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
All what you need to do is to add:
```ruby
# config/production(development|test|staging|preview).rb

config.cache_store = :redis_hash_store, redis_cache_store_options
```

## Usage
This gem is just adding new functionality to `RedisCacheStore`.
So all previous logic is not affected.

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

Looks pretty easy, right? Maybe you can even think: "What the difference?"

Let me show you:

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
3. or even whole "group":
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
One of the reasons why we decided to create this Gem is [`#delete_matched`](https://apidock.com/rails/ActiveSupport/Cache/Store/delete_matched).
We had the same issue as GitLab: you can check it [here](https://gitlab.com/gitlab-org/gitlab/-/issues/201808)

Second one is that `#delete_matched` is not scan all the nodes in case if you use `Redis Cluster`.

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

## License
redis_hash_store is Copyright ©2020 Alex Golubenko and Mrsool.

Please, see: [LICENSE](https://github.com/mrsool/redis_hash_store/blob/master/LICENSE)

## About Mrsool
<img src="https://miro.medium.com/max/2000/1*SRVN-sOkDz1if2YtezsCSQ.png" width="500">

Mrsool (pronounced mar-sool) is the first deliver-anything platform in the MENA region, founded in 2015 by Ayman Al Sanad and Nayef Al Samri, Mrsool is the largest Saudi app of its kind in the region!

With more than 1.7 billion Saudi Riyals GMV in 2019, and continued hypergrowth across three countries, Mrsool has solved many technical and operational challenges by being customer-obsessed and engineering-driven in every single decision made.
We’re proudly a community of people helping each other, in fact, more than 70% of Mrsoolers (our professional couriers) have ordered from Mrsool. It’s one massive community of carefully vetted professionals.

[Read more](https://medium.com/mrsool/mrsool-the-super-app-with-super-powers-423c3037d31a)..
