# frozen_string_literal: true

require 'active_support/core_ext/integer/time'

Rails.application.configure do
  Rails.application.routes.default_url_options[:host] = 'localhost:3000'
  config.hosts.clear

  configure_caching
  configure_active_storage
  configure_action_mailer
  configure_deprecation
  configure_assets
  configure_file_watcher
end

private

def configure_caching
  config.cache_classes = false
  config.eager_load = false
  config.consider_all_requests_local = true

  if Rails.root.join('tmp/caching-dev.txt').exist?
    enable_caching
  else
    disable_caching
  end
end

def enable_caching
  config.action_controller.perform_caching = true
  config.action_controller.enable_fragment_cache_logging = true
  config.cache_store = :memory_store
  config.public_file_server.headers = {
    'Cache-Control' => "public, max-age=#{2.days.to_i}"
  }
end

def disable_caching
  config.action_controller.perform_caching = false
  config.cache_store = :null_store
end

def configure_active_storage
  config.active_storage.service = :local
end

def configure_action_mailer
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.perform_caching = false
end

def configure_deprecation
  config.active_support.deprecation = :log
  config.active_support.disallowed_deprecation = :raise
  config.active_support.disallowed_deprecation_warnings = []
  config.active_record.migration_error = :page_load
  config.active_record.verbose_query_logs = true
end

def configure_assets
  config.assets.debug = true
  config.assets.quiet = true
end

def configure_file_watcher
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker
end
