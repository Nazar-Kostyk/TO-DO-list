# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.4', require: false
gem 'jbuilder', '~> 2.7'
gem 'lefthook'
gem 'pg', '~> 1.1'
gem 'pg_query'
gem 'prosopite'
gem 'puma', '~> 5.0'
gem 'rails', '~> 6.1.4', '>= 6.1.4.1'
gem 'rubocop', require: false
gem 'rubocop-rails'
gem 'rubocop-rspec'
gem 'simplecov', require: false, group: :test

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails'
  gem 'rspec-rails', '~> 5.0.0'
end

group :development do
  gem 'annotate'
  gem 'brakeman'
  gem 'listen', '~> 3.3'
  gem 'spring'
end

group :test do
  gem 'shoulda-matchers', '~> 5.0'
end

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
