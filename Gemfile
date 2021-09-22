# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby File.read('.ruby-version').strip

gem 'rails', '~> 6.1.4', '>= 6.1.4.1'

gem 'bcrypt', '>= 3.1.16'
# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.4', require: false
gem 'dry-validation', '>= 1.6.0'
gem 'jsonapi-serializer', '>= 2.2.0'
gem 'jwt', '>= 2.2.3'
gem 'pg', '>= 1.1'
gem 'puma', '~> 5.0'

group :development, :test do
  gem 'byebug', '>= 11.1.3', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails', '>= 6.2.0'
  gem 'pry-byebug', '~> 3.9.0'
  gem 'pry-rails', '~> 0.3.9'
end

group :development do
  gem 'annotate', '>= 3.1.1'
  gem 'brakeman', '>= 5.1.1'
  gem 'bundler-audit', '>= 0.9.0.1'
  gem 'bundler-leak', '>= 0.2.0'
  gem 'lefthook', '>= 0.7.6'
  gem 'listen', '~> 3.3'
  gem 'rails_best_practices', '>= 1.21.0'
  gem 'rubocop', '>= 1.20.0', require: false
  gem 'rubocop-performance', '>= 1.11.5'
  gem 'rubocop-rails', '>= 2.11.3'
  gem 'rubocop-rake', '>= 0.6.0'
  gem 'rubocop-rspec', '>= 2.4.0'
  gem 'spring', '>= 2.1.1'
end

group :test do
  gem 'database_cleaner-active_record', '~> 2.0.1'
  gem 'dry-validation-matchers', '>= 1.2.2'
  gem 'faker', '>= 2.19.0'
  gem 'json_matchers', '>= 0.11'
  gem 'prosopite', '>= 1.0.1'
  gem 'rspec-rails', '~> 5.0.0'
  gem 'shoulda-matchers', '~> 5.0'
  gem 'simplecov', '>= 0.21.2', require: false, group: :test
end
