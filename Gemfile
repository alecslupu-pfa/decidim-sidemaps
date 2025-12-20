# frozen_string_literal: true

source "https://rubygems.org"

gem "decidim", "0.29.1"
gem "decidim-sitemaps", path: "."
gem "decidim-verifications", "0.29.1"

gem "bootsnap", "~> 1.3"

group :development do
  gem "letter_opener_web", "~> 1.4"
end

group :development, :test do
  gem "decidim-dev", "0.29.1"
  gem "rubocop-performance"
  gem "simplecov", require: false
end
