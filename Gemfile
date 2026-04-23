source "https://rubygems.org"

gem "rails", "~> 8.1.3"

gem 'aasm'
gem "propshaft"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"

gem 'dartsass-rails'
gem 'bootstrap', '~> 5.3.3'
gem 'bootstrap-icons-helper'

gem "bcrypt", "~> 3.1.7"
gem 'valid_email2'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Use the database-backed adapters for Rails.cache, Active Job, and Action Cable
gem "solid_cache"
gem "solid_queue"
gem "solid_cable"

gem "bootsnap", require: false
gem "kamal", require: false
gem "thruster", require: false
gem "image_processing", "~> 1.2"

group :development, :test do
  gem 'brakeman', require: false
  gem 'bundler-audit', require: false
  gem 'capybara'
  gem 'debug', platforms: %i[ mri windows ], require: 'debug/prelude'
  gem 'factory_bot_rails', '~> 6.5.0'
  gem 'rspec-rails', '~> 8.0.0'
  gem 'rubocop-rails-omakase', require: false
end

group :development do
  gem "web-console"
end
