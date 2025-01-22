# spec/initializers/sentry_spec.rb
require 'rails_helper'
RSpec.describe 'Sentry Initialization', type: :initialization do
  let(:event) { double('event', exception: { 'error' => double('value', value: 'Test Error') }, event_id: '12345') }

  before do
    allow(SlackNotifier).to receive(:send_error_to_slack)
  end

  it 'calls SlackNotifier.send_error_to_slack before sending an event to Sentry' do
    Sentry.configuration.before_send.call(event, nil)
    expect(SlackNotifier).to have_received(:send_error_to_slack).with(event)
  end
end
