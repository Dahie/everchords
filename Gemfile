# frozen_string_literal: true

source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0'
# Use Puma as the app server
gem 'puma', '~> 3.12'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use of devise and Omniauth for authentication
gem 'aasm'
gem 'devise'
gem 'devise-i18n'
gem 'evernote_oauth'
gem 'evernote_utils'
gem 'friendly_id', '~> 5.2.4'
gem 'haml-rails'
gem 'html_to_plain_text'
gem 'httparty'
gem 'interactor-rails'
gem 'omniauth'
gem 'omniauth-evernote'

gem 'jbuilder', '~> 2.5'
gem 'jquery-rails'
gem 'semantic-ui-sass'
gem 'turbolinks', '~> 5'

gem 'figaro'
gem 'song_pro', git: 'git@github.com:Dahie/songpro-ruby.git', branch: 'no-trim-lyrics'

group :production do
  gem 'pg'
end

group :development, :test do
  gem 'byebug', platform: :mri
  gem 'database_cleaner'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'rspec-rails'
  gem 'rubocop', require: false
  gem 'rubocop-rails'
  gem 'sqlite3'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console'
end
