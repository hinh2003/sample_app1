# frozen_string_literal: true

# config/initializers/omniauth.rb

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, ENV['GITHUB_CLIENT_ID'], ENV['GITHUB_CLIENT_SECRET'], scope: 'user:email'
  provider :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET'], {
    scope: 'email, profile, https://www.googleapis.com/auth/drive.readonly, https://www.googleapis.com/auth/spreadsheets',
    prompt: 'select_account'
  }
  provider :facebook, ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_APP_SECRET']
end
