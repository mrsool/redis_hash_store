# frozen_string_literal: true

if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new('3.1.0') || Gem::Version.new(RUBY_VERSION) <= Gem::Version.new('3.2.1')
  appraise "rails7.0" do
    gem "rails", "~> 7.0"
  end
end

if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new('2.6.0') || Gem::Version.new(RUBY_VERSION) <= Gem::Version.new('2.7.7')
  appraise "rails5.2" do
    gem "rails", "~> 5.2"
  end
end

if Gem::Version.new(RUBY_VERSION) <= Gem::Version.new('3.2.1')
  appraise "rails6.0" do
    gem "rails", "~> 6.0"
  end

  appraise "rails6.1" do
    gem "rails", "~> 6.1"
  end
end
