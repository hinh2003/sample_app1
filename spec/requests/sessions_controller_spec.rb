# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'SessionsController', type: :request do
  describe 'GET #create_third_party' do
    before do
      OmniAuth.config.mock_auth[:github] = github_auth
      OmniAuth.config.mock_auth[:facebook] = facebook_auth
      OmniAuth.config.mock_auth[:google_oauth2] = google_auth
    end

    describe 'Successful third-party logins' do
      include_examples 'logs in user via third-party', 'github', 'user@example.com'
      include_examples 'logs in user via third-party', 'facebook', 'facebook_user@example.com'
      include_examples 'logs in user via third-party', 'google_oauth2', 'google_user@example.com'
    end

    describe 'Failed third-party logins' do
      include_examples 'fails login via third-party', 'github'
      include_examples 'fails login via third-party', 'facebook'
      include_examples 'fails login via third-party', 'google_oauth2'
    end
  end
end
