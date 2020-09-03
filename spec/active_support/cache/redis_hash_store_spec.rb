# frozen_string_literal: true

require "spec_helper"

RSpec.describe ActiveSupport::Cache::RedisHashStore do
  describe '#write_hash_value' do
    it 'writes values as redis hash' do
      Rails.cache.write_hash_value('foo', 'boo', 'bar')
      Rails.cache.write_hash_value('foo', 'baz', 'boo')

      expect(redis.hexists('foo', 'boo')).to eq(true)
      expect(redis.hexists('foo', 'baz')).to eq(true)
    end
  end

  describe '#read_hash_value' do
    it 'returns value from redis hash by prefix and key' do
      value_one = 'bar'
      value_two = 'boo'
      Rails.cache.write_hash_value('foo', 'boo', value_one)
      Rails.cache.write_hash_value('foo', 'baz', value_two)

      expect(Rails.cache.read_hash_value('foo', 'boo')).to eq(value_one)
      expect(Rails.cache.read_hash_value('foo', 'baz')).to eq(value_two)
    end
  end

  describe '#delete_hash_value' do
    it 'removes value by prefix and key' do
      prefix = 'foo'
      key_1 = 'boo'
      key_2 = 'bar'
      value_1 = 'baz'
      value_2 = 'bee'

      Rails.cache.write_hash_value(prefix, key_1, value_1)
      Rails.cache.write_hash_value(prefix, key_2, value_2)

      expect(Rails.cache.read_hash_value(prefix, key_1)).to eq(value_1)
      expect(Rails.cache.read_hash_value(prefix, key_2)).to eq(value_2)

      Rails.cache.delete_hash_value(prefix, key_1)

      expect(Rails.cache.read_hash_value(prefix, key_1)).to eq(nil)
      expect(Rails.cache.read_hash_value(prefix, key_2)).to eq(value_2)
    end
  end

  describe '#fetch_hash_value' do
    context 'when value cached' do
      it 'returns cached value' do
        cached_value = 'bar'
        new_value = 'baz'
        Rails.cache.write_hash_value('foo', 'boo', cached_value)

        result = Rails.cache.fetch_hash_value('foo', 'boo') { new_value }

        expect(result).to eq(cached_value)
        expect(Rails.cache.read_hash_value('foo', 'boo')).to eq(cached_value)
      end
    end

    context 'when value not cached' do
      it 'writes and then returns new value' do
        expected_value = 'bar'
        result = Rails.cache.fetch_hash_value('foo', 'boo') { expected_value }

        expect(result).to eq(expected_value)
        expect(Rails.cache.read_hash_value('foo', 'boo')).to eq(expected_value)
      end
    end

    context 'when value cached and force: true' do
      it 'returns new cached value' do
        cached_value = 'bar'
        new_value = 'baz'
        Rails.cache.write_hash_value('foo', 'boo', cached_value)

        result = Rails.cache.fetch_hash_value('foo', 'boo', force: true) { new_value }

        expect(result).to eq(new_value)
        expect(Rails.cache.read_hash_value('foo', 'boo')).to eq(new_value)
      end
    end
  end

  describe '#read_hash' do
    it 'returns hash with key => value' do
      prefix = 'foo'
      key_1 = 'boo'
      key_2 = 'bar'
      value_1 = 'baz'
      value_2 = 'bee'

      expected_result = {
        key_1 => value_1,
        key_2 => value_2,
      }

      Rails.cache.write_hash_value(prefix, key_1, value_1)
      Rails.cache.write_hash_value(prefix, key_2, value_2)

      expect(Rails.cache.read_hash(prefix)).to eq(expected_result)
    end
  end

  describe '#delete_hash' do
    it 'removes all values by prefix' do
      prefix = 'foo'
      key_1 = 'boo'
      key_2 = 'bar'
      value_1 = 'baz'
      value_2 = 'bee'

      Rails.cache.write_hash_value(prefix, key_1, value_1)
      Rails.cache.write_hash_value(prefix, key_2, value_2)

      expect(Rails.cache.read_hash_value(prefix, key_1)).to eq(value_1)
      expect(Rails.cache.read_hash_value(prefix, key_2)).to eq(value_2)

      Rails.cache.delete_hash(prefix)

      expect(Rails.cache.read_hash_value(prefix, key_1)).to eq(nil)
      expect(Rails.cache.read_hash_value(prefix, key_2)).to eq(nil)
    end
  end

  def redis
    Rails.cache.redis
  end
end
