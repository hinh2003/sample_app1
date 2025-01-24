# frozen_string_literal: true

# spec/services/slack_notifier_spec.rb
require 'rails_helper'

RSpec.describe SlackNotifier, type: :service do
  describe '.send_error_to_slack' do
    let(:event) { double('event', exception: { 'error' => double('value', value: 'Test Error') }, event_id: '12345') }
    let(:slack_webhook_url) { 'https://hooks.slack.com/test' }
    let(:sentry_url) { 'https://sentry.io/test_project' }

    before do
      allow(ENV).to receive(:[]).with('SLACK_HOOK').and_return(slack_webhook_url)
      allow(ENV).to receive(:[]).with('SENTRY_URL').and_return(sentry_url)
      allow(SlackNotifier).to receive(:send_to_slack)
    end

    it 'sends an error message to Slack' do
      SlackNotifier.send_error_to_slack(event)

      expect(SlackNotifier).to have_received(:send_to_slack).with(
        slack_webhook_url,
        kind_of(Hash)
      )
    end
  end
end
