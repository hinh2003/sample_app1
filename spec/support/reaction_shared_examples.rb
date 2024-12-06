# frozen_string_literal: true

shared_examples_for 'reaction_add' do
  context 'with valid parameters' do
    it 'creates a new reaction and returns a success response' do
      post '/microposts/reactions', params: { reaction_type: 'Like', micropost_id: micropost.id }
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response['success']).to eq(true)
      expect(json_response['message']).to eq('Reaction saved successfully.')
      expect(json_response['reaction_type']).to eq('Like')
    end
  end
  context 'with invalid parameters' do
    it 'does not create a new reaction and returns home' do
      post '/microposts/reactions', params: { reaction_type: 'Like', micropost_id: 1000 }
      expect(response).to redirect_to(root_url)
    end
  end
end

shared_examples_for 'reaction_delete' do
  context 'when reaction exists' do
    it 'deletes the reaction and redirects to the previous page' do
      request.env['HTTP_REFERER'] = '/users/1'
      expect do
        delete :destroy, params: { micropost_id: micropost.id }
      end
      expect(response).to redirect_to(request.referer)
    end
  end
  context 'when micropost does not exist' do
    it 'does NOT delete the reaction and redirects to the previous page' do
      request.env['HTTP_REFERER'] = '/users/1'
      expect do
        delete :destroy, params: { micropost_id: nil }
      end
      expect(response).to redirect_to(request.referer)
    end
  end
end
