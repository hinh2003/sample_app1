# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReactionsController, type: :request do
  let(:user) { create(:user) }
  let(:micropost) { create(:micropost, user: user) }
  before do
    post '/login', params: { session: { email: user.email, password: 'password123' } }
    session[:user_id] = user.id
  end
  describe 'POST /microposts/reactions' do
    include_examples 'reaction_add'
  end
  describe 'DELETE /microposts/:micropost_id/reactions' do
    include_examples 'reaction_delete'
  end
end
