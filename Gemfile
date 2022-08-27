# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby File.read('.ruby-version').strip

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 7.0'
# Use Puma as the app server
gem 'puma', '~> 5.6'
# Use SCSS for stylesheets
gem 'sassc-rails'

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
gem 'fomantic-ui-sass'
gem 'friendly_id', '~> 5.4'
gem 'haml-rails'
gem 'html_to_plain_text'
gem 'httparty'
gem 'interactor-rails'
gem 'jbuilder', '~> 2.5'
gem 'jquery-rails'
gem 'omniauth', '~> 2'
gem 'omniauth-evernote'
gem 'omniauth-rails_csrf_protection', '~> 1.0.0'
gem 'pg'
gem 'rails_admin', '3.0.0.beta'
gem 'rails_admin_aasm'
gem 'song_pro'
gem 'sprockets', '3.7.2'
gem 'sprockets-rails'
gem 'stimulus-rails'

group :development, :test do
  gem 'brakeman'
  gem 'bundler-audit'
  gem 'byebug', platform: :mri
  gem 'database_cleaner'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'rails-controller-testing'
  gem 'rspec-rails'
  gem 'rubocop', require: false
  gem 'rubocop-rails'
  gem 'rubocop-rspec'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'listen', '~> 3.0.5'
  gem 'web-console'
end

gem 'importmap-rails', '~> 1.1'
