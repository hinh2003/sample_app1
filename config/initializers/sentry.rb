# frozen_string_literal: true

Sentry.init do |config|
  config.dsn = ENV['SENTRY_DNS']
  config.breadcrumbs_logger = %i[active_support_logger http_logger]

  # Set traces_sample_rate to 1.0 to capture 100%
  # of transactions for tracing.
  # We recommend adjusting this value in production.
  config.traces_sample_rate = 1.0
  # or
  config.traces_sampler = lambda do |_context|
    true
  end
  config.before_send = lambda do |event, _hint|
    send_error_to_slack(event)
    event
  end
  # Set profiles_sample_rate to profile 100%
  # of sampled transactions.
  # We recommend adjusting this value in production.
  config.profiles_sample_rate = 1.0
end

def send_error_to_slack(event)
  slack_webhook_url = ENV['SLACK_HOOK']
  return unless slack_webhook_url

  error_message = event.exception&.values&.first&.value || 'Unknown error'
  timestamp = Time.zone.now.strftime('%Y-%m-%d %H:%M:%S')
  sentry_url = "#{ENV['SENTRY_URL']}/#{event.event_id}"
  payload = build_slack_payload(error_message, timestamp, sentry_url)

  send_to_slack(slack_webhook_url, payload)
end


def build_slack_payload(error_message, timestamp, sentry_url)
  {
    text: '*Sentry Error Notification* :rotating_light:',
    attachments: [
      {
        color: '#ff0000',
        fields: [
          { title: 'Error Message', value: error_message, short: false },
          { title: 'Timestamp', value: timestamp, short: true },
          { title: 'Sentry Link', value: "<#{sentry_url}|View in Sentry>", short: false }
        ]
      }
    ]
  }
end

def send_to_slack(slack_webhook_url, payload)
  uri = URI(slack_webhook_url)

  begin
    response = Net::HTTP.post(uri, payload.to_json, 'Content-Type' => 'application/json')
    Rails.logger.error("Failed to send error to Slack: #{response.body}") unless response.is_a?(Net::HTTPSuccess)
  rescue StandardError => e
    Rails.logger.error("Error while sending notification to Slack: #{e.message}")
  end
end
