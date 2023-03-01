# frozen_string_literal: true

if %w[3.2 3.1].include?(RUBY_VERSION)
  appraise "rails7.0" do
    gem "rails", "~> 7.0"
  end
end

if %w[2.6 2.7].include?(RUBY_VERSION)
  appraise "rails5.2" do
    gem "rails", "~> 5.2.0"
  end
end

if RUBY_VERSION != "3.2"
  appraise "rails6.0" do
    gem "rails", "~> 6.0.2"
  end

  appraise "rails6.1" do
    gem "rails", "~> 6.1"
  end
end
