# frozen_string_literal: true

module ActiveSupport
  module Cache
    class RedisHashStore < RedisCacheStore
      MISSING_BLOCK_MSG = "Missing block: Calling `Cache#fetch` with `force: true` requires a block."

      def initialize(options)
        super(**options)
      end

      def write_hash_value(prefix, key, value, **options)
        instrument(:write_hash_value, [prefix, key], options) do
          entry = Entry.new(value, **options)
          write_hash_entry(prefix, key, entry)
        end
      end

      def read_hash_value(prefix, key)
        instrument(:read_hash_value, [prefix, key]) do |payload|
          entry = read_hash_entry(prefix, key)

          if entry
            if entry.expired?
              delete_hash_entry(key)
              payload[:hit] = false if payload
              nil
            else
              payload[:hit] = true if payload
              entry.value
            end
          else
            payload[:hit] = false if payload
            nil
          end
        end
      end

      def fetch_hash_value(prefix, key, **options)
        force = options[:force]

        raise(ArgumentError, MISSING_BLOCK_MSG) if !block_given? && force

        if block_given?
          entry = read_hash_value(prefix, key)

          return entry if entry.present? && !force

          write_hash_value(prefix, key, yield, options)
        end

        read_hash_value(prefix, key)
      end

      def delete_hash_value(prefix, key)
        instrument(:delete_hash_value, [prefix, key]) do
          delete_hash_entry(prefix, key)
        end
      end

      def read_hash(prefix)
        instrument(:read_hash, prefix) do
          read_hash_entries(prefix).map do |key, entry|
            if entry.expired?
              delete_hash_entry(prefix, key)
              nil
            else
              [key, entry.value]
            end
          end.compact.to_h
        end
      end

      def delete_hash(prefix)
        instrument(:delete_hash, prefix) do
          delete_hash_entries(prefix)
        end
      end

      private

      def delete_hash_entry(prefix, key)
        failsafe(:delete_hash_entry, returning: false) do
          redis.with { |c| c.hdel(prefix, key) }
        end
      end

      def read_hash_entry(prefix, key)
        failsafe(:read_hash_entry) do
          deserialize_entry(redis.with { |c| c.hget(prefix, key) }, raw: false)
        end
      end

      def write_hash_entry(prefix, key, entry)
        serialized_entry = serialize_entry(entry)

        failsafe(:write_hash_entry, returning: false) do
          redis.with do |connection|
            connection.hset(prefix, key, serialized_entry)
          end
        end
      end

      def read_hash_entries(prefix)
        failsafe(:write_hash_entry, returning: false) do
          redis.with do |connection|
            connection.hgetall(prefix).transform_values do |value|
              deserialize_entry(value, raw: false)
            end
          end
        end
      end

      def delete_hash_entries(prefix)
        redis.with { |c| c.del(prefix) }
      end
    end
  end
end
