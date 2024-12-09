# frozen_string_literal: true

shared_examples_for 'reaction_add' do
  context 'with valid parameters' do
    it 'creates a new reaction and returns a success response' do
      post '/microposts/reactions', params: { reaction_type: '0', micropost_id: micropost.id }
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response['success']).to eq(true)
      expect(json_response['message']).to eq('Reaction saved successfully.')
      reaction = Reaction.last
      expect(reaction.micropost_id).to eq(micropost.id)
    end
  end
  context 'with invalid parameters' do
    it 'does not create a new reaction and returns home' do
      initial_reaction_count = Reaction.count
      post '/microposts/reactions', params: { reaction_type: 'Like', micropost_id: 1000 }
      expect(response).to redirect_to(root_url)
      expect(Reaction.count).to eq(initial_reaction_count)
    end
  end
end

shared_examples_for 'reaction_delete' do
  context 'when reaction exists' do
    it 'deletes the reaction and redirects to the previous page' do
      request.env['HTTP_REFERER'] = '/users/1'
      expect do
        delete destroy_reaction_path(micropost_id: micropost.id)
      end.to change(Reaction, :count).by(-1)
      expect(response).to redirect_to(request.referer)
    end
  end
  context 'when micropost does not exist' do
    it 'does NOT delete the reaction and redirects to the previous page' do
      request.env['HTTP_REFERER'] = '/users/1'

      expect do
        delete destroy_reaction_path(micropost_id: nil)
      end

      expect(response).to redirect_to(request.referer)
    end
  end
end
