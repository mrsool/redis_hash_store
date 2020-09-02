# frozen_string_literal: true

require "spec_helper"

RSpec.describe RedisHashStore do
  it { expect(Rails.cache).to be_an ActiveSupport::Cache::Store }
  it { expect(Rails.cache).to be_an ActiveSupport::Cache::RedisCacheStore }
end
