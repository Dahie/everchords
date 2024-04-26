# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.5'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 7.0'
# Use Puma as the app server
gem 'puma', '~> 6'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'

# Use of devise and Omniauth for authentication
gem 'aasm'
gem 'appsignal'
gem 'cancancan'
gem 'chord_diagrams'
gem 'coltrane'
gem 'devise'
gem 'devise-i18n'
gem 'evernote_oauth'
gem 'evernote_utils'
gem 'fomantic-ui-sass', '~> 2.8', '< 2.9'
gem 'friendly_id', '~> 5'
gem 'haml-rails'
gem 'html_to_plain_text'
gem 'httparty'
gem 'jbuilder', '~> 2'
gem 'jquery-rails'
gem 'omniauth'
gem 'omniauth-evernote'
gem 'omniauth-rails_csrf_protection', '~> 1'
gem 'pg'
gem 'rails_admin', '3.1.2'
gem 'rails_admin_aasm'
gem 'song_pro'
gem 'sprockets', '4.2.1'
gem 'sprockets-rails'
gem 'stimulus-rails'
gem 'turbo-rails'

group :development, :test do
  gem 'brakeman'
  gem 'bundler-audit'
  gem 'byebug', platform: :mri
  gem 'capybara'
  gem 'database_cleaner'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'rails-controller-testing'
  gem 'rspec-rails'
  gem 'rubocop', require: false
  gem 'rubocop-factory_bot'
  gem 'rubocop-rails'
  gem 'rubocop-rspec'
  gem 'rubocop-performance'
  gem 'selenium-webdriver'
  gem 'webdrivers'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'listen', '~> 3.9.0'
  gem "ruby-lsp-rspec", require: false
  gem 'web-console'
end

gem 'openssl'

gem 'importmap-rails', '~> 2'

gem "dockerfile-rails", ">= 1.0", group: :development

gem "service_actor-rails", "~> 1"
