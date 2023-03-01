# frozen_string_literal: true

if [3.1..3.2].include?(RUBY_VERSION.to_f)
  appraise "rails7.0" do
    gem "rails", "~> 7.0"
  end
end

if [2.6..2.7].include?(RUBY_VERSION.to_f)
  appraise "rails5.2" do
    gem "rails", "~> 5.2"
  end
end

if RUBY_VERSION.to_f <= 3.2
  appraise "rails6.0" do
    gem "rails", "~> 6.0"
  end

  appraise "rails6.1" do
    gem "rails", "~> 6.1"
  end
end
