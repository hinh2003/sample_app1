# frozen_string_literal: true

Sentry.init do |config|
  config.dsn = ENV['SENTRY_DNS']
  config.breadcrumbs_logger = %i[active_support_logger http_logger]
  config.traces_sample_rate = 1.0
  config.traces_sampler = lambda do |_context|
    true
  end
  config.before_send = lambda do |event, _hint|
    SlackNotifier.send_error_to_slack(event)
    event
  end
  config.profiles_sample_rate = 1.0
end
