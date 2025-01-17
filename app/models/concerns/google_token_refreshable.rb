# frozen_string_literal: true

# this is GoogleTokenRefreshable
module GoogleTokenRefreshable
  extend ActiveSupport::Concern

  def refresh_google_token
    return if google_refresh_token.nil?

    client = Signet::OAuth2::Client.new(
      client_id: ENV['GOOGLE_CLIENT_ID'],
      client_secret: ENV['GOOGLE_CLIENT_SECRET'],
      token_credential_uri: 'https://oauth2.googleapis.com/token',
      refresh_token: google_refresh_token
    )

    response = client.refresh!

    update(
      google_access_token: response['access_token'],
      google_token_expires_at: Time.zone.now + response['expires_in'].seconds
    )

    response['access_token']
  end

  def ensure_google_access_token
    if google_access_token.nil? || google_token_expires_at < Time.zone.now
      refresh_google_token
    end
    google_access_token
  end
end
