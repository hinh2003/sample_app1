# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)
module SampleApp
  # this is Application SampleApp
  class Application < Rails::Application
    config.load_defaults 6.1
    config.action_view.embed_authenticity_token_in_remote_forms = true
    config.autoload_paths += %W[#{config.root}/app/decorators]
    config.i18n.default_locale = :vi
  end
end
