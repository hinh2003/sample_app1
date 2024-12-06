# frozen_string_literal: true

# spec/support/omniauth_shared_examples.rb

shared_examples 'logs in user via third-party' do |provider, email|
  it "logs in the user by #{provider}" do
    get "/auth/#{provider}/callback", env: { 'omniauth.auth' => OmniAuth.config.mock_auth[provider.to_sym] }
    user = User.find_by(email: email)
    expect(session[:user_id]).to eq(user.id)
    expect(response).to redirect_to(user_path(user))
  end
end

shared_examples 'fails login via third-party' do |provider|
  it "fails to log in the user by #{provider}" do
    OmniAuth.config.mock_auth[provider.to_sym] = :invalid_credentials
    get "/auth/#{provider}/callback", env: { 'omniauth.auth' => OmniAuth.config.mock_auth[provider.to_sym] }
    expect(session[:user_id]).to be_nil
  end
end
