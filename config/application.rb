# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SampleApp
  # This class configures the core settings for the Rails application.
  # It initializes defaults for the application and sets specific options for
  # various features like embedding the authenticity token in remote forms.
  # Custom configurations for different environments can be set in the config/environments/* files.
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1
    config.action_view.embed_authenticity_token_in_remote_forms = true
    config.time_zone = 'Hanoi'
    config.active_record.default_timezone = :utc
    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
