# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Everchords
  class Application < Rails::Application
    config.load_defaults 5.0

    config.assets.enabled = true
    config.assets.paths <<
      Rails.root.join('app', 'assets', 'images', 'favicons')
  end
end
