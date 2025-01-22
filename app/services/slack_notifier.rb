# frozen_string_literal: true

# app/services/slack_notifier.rb
class SlackNotifier
  def self.send_error_to_slack(event)
    slack_webhook_url = ENV['SLACK_HOOK']
    return if slack_webhook_url.blank?

    error_message = event.exception&.values&.first&.value || 'Unknown error'
    timestamp = Time.zone.now.strftime('%Y-%m-%d %H:%M:%S')
    sentry_url = "#{ENV['SENTRY_URL']}/#{event.event_id}"

    payload = SlackPayloadBuilder.new(error_message, timestamp, sentry_url).build
    send_to_slack(slack_webhook_url, payload)
  end

  def self.send_to_slack(slack_webhook_url, payload)
    uri = URI(slack_webhook_url)

    begin
      response = Net::HTTP.post(uri, payload.to_json, 'Content-Type' => 'application/json')
      Rails.logger.error("Failed to send error to Slack: #{response.body}") unless response.is_a?(Net::HTTPSuccess)
    rescue StandardError => e
      Rails.logger.error("Error while sending notification to Slack: #{e.message}")
    end
  end
end
