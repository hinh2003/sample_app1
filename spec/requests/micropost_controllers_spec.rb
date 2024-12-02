# frozen_string_literal: true

# spec/requests/micropost_controllers_spec.rb

require 'rails_helper'

RSpec.describe MicropostsController, type: :request do
  include SessionsHelper
  let(:user) { create(:user) }
  let(:micropost) { create(:micropost, user: user) }
  let(:comment) { create(:micropost, user: user, parent_id: micropost.id) }
  before do
    post '/login', params: { session: { email: user.email, password: 'password123' } }
    session[:user_id] = user.id
  end
  describe 'GET /microposts/:id' do
    include_examples 'micropost exists?'
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
