# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby File.read('.ruby-version').strip

gem 'rails', '~> 6.1.4', '~> 6.1.4.1'

gem 'bcrypt', '~> 3.1'
# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '~> 1.4.4', require: false
gem 'dry-validation', '~> 1.6'
gem 'jsonapi-serializer', '~> 2.2'
gem 'jwt_sessions', '~> 2.6'
gem 'pg', '~> 1.1'
gem 'puma', '~> 5.5'
gem 'redis', '~> 4.4'
gem 'redis-namespace', '~> 1.8'
gem 'redis-rails', '~> 5.0'

group :development, :test do
  gem 'byebug', '~> 11.1', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails', '~> 6.2'
  gem 'pg_query', '~> 2.1'
  gem 'pry-byebug', '~> 3.9'
  gem 'pry-rails', '~> 0.3'
  gem 'traceroute', '~> 0.8'
end

group :development do
  gem 'annotate', '~> 3.1'
  gem 'brakeman', '~> 5.1'
  gem 'bundler-audit', '~> 0.9.0'
  gem 'bundler-leak', '~> 0.2'
  gem 'lefthook', '~> 0.7'
  gem 'listen', '~> 3.3'
  gem 'rubocop', '~> 1.20', require: false
  gem 'rubocop-performance', '~> 1.11'
  gem 'rubocop-rails', '~> 2.11'
  gem 'rubocop-rake', '~> 0.6'
  gem 'rubocop-rspec', '~> 2.4'
  gem 'spring', '~> 2.1'
end

group :test do
  gem 'database_cleaner-active_record', '~> 2.0'
  gem 'faker', '~> 2.19'
  gem 'json_matchers', '~> 0.11'
  gem 'prosopite', '~> 1.0'
  gem 'rspec-rails', '~> 5.0'
  gem 'shoulda-matchers', '~> 5.0'
  gem 'simplecov', '~> 0.21', require: false, group: :test
end
