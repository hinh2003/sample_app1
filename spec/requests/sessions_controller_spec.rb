require 'rails_helper'

RSpec.describe 'SessionsController', type: :request do
  describe 'GET #create_third_party' do
    let(:auth) do
      OmniAuth::AuthHash.new({
                               provider: 'github',
                               uid: '1234567890',
                               info: {
                                 email: 'user@example.com',
                                 name: 'John Doe'
                               }
                             })
    end

    before do
      OmniAuth.config.mock_auth[:github] = auth
    end

    it 'logs in the user by github' do
      get '/auth/github/callback', env: { 'omniauth.auth' => OmniAuth.config.mock_auth[:github] }
      user = User.find_by(email: 'user@example.com')
      expect(session[:user_id]).to eq(user.id)
      expect(response).to redirect_to(user_path(user))
    end

  end
end
