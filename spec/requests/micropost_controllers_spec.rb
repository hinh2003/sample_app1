# frozen_string_literal: true

# spec/requests/micropost_controllers_spec.rb

require 'rails_helper'

RSpec.describe MicropostsController, type: :request do
  describe 'GET /microposts/:id' do
    let(:user) { create(:user) }
    let(:micropost) { create(:micropost, user: user) }

    context 'when micropost exists ' do
      before { get micropost_path(id: micropost.id) }

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end
      it 'includes micropost data in the response body' do
        expect(response.body).to include(micropost.content)
      end
    end
    context 'when micropost does not exist' do
      before { get micropost_path(id: 999) }

      it 'redirects to root url' do
        expect(response).to redirect_to(root_url)
      end
      it 'sets a flash message' do
        follow_redirect!
        expect(response.body).to include('Micropost not found')
      end
    end
  end
end

RSpec.describe MicropostsController, type: :request do
  include SessionsHelper

  let(:user) { create(:user) }
  let(:micropost) { create(:micropost, user: user) }
  let(:comment) { create(:micropost, user: user, parent_id: micropost.id) }

  before do
    post '/login', params: { session: { email: user.email, password: 'password123' } }
    session[:user_id] = user.id
  end

  describe 'POST /create_comment' do
    include_examples 'with valid params'
  end

  describe 'POST /create_comment with invalid params' do
    include_examples 'when content is empty'
    include_examples 'when parent_id is invalid'
  end
  describe 'DELETE /microposts/:id' do
    include_examples 'destroy micropost'
  end
  describe 'PUT /microposts/:id' do
    include_examples 'update micropost'
  end
end

