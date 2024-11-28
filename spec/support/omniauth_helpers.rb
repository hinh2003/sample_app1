# frozen_string_literal: true

# spec/support/omniauth_helpers.rb
module OmniAuthHelpers
  def github_auth
    OmniAuth::AuthHash.new({
                             provider: 'github',
                             uid: '1234567890',
                             info: {
                               email: 'user@example.com',
                               name: 'John Doe'
                             }
                           })
  end

  def facebook_auth
    OmniAuth::AuthHash.new({
                             provider: 'facebook',
                             uid: '0987654321',
                             info: {
                               email: 'facebook_user@example.com',
                               name: 'Jane Doe'
                             }
                           })
  end

  def google_auth
    OmniAuth::AuthHash.new({
                             provider: 'google_oauth2',
                             uid: '1122334455',
                             info: {
                               email: 'google_user@example.com',
                               name: 'Sam Smith'
                             }
                           })
  end

  def auth_failure
    OmniAuth::AuthHash.new({
                             provider: 'github',
                             uid: nil,
                             info: {}
                           })
  end
end
