# frozen_string_literal: true

Slack.configure do |config|
  config.token = ENV['SLACK_API']
end
