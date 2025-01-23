# frozen_string_literal: true

# app/services/slack_payload_builder.rb
class SlackPayloadBuilder
  def initialize(error_message, timestamp, sentry_url)
    @error_message = error_message
    @timestamp = timestamp
    @sentry_url = sentry_url
  end

  def build
    {
      text: I18n.t('messages.error_notification'),
      attachments: [
        {
          color: '#ff0000',
          fields: [
            { title: I18n.t('messages.error_message'), value: @error_message, short: false },
            { title: I18n.t('messages.timestamp'), value: @timestamp, short: true },
            { title: I18n.t('messages.sentry_link'), value: "<#{@sentry_url}|#{I18n.t('messages.view_in_sentry')}>", 
              short: false }
          ]
        }
      ]
    }
  end
end
