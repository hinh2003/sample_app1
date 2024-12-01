shared_examples 'with valid params' do
  let(:valid_params) { { content: 'A new comment', parent_id: micropost.id } }

  it 'creates a new comment and redirects to the micropost page' do
    request.env['HTTP_REFERER'] = micropost_path(micropost.id)
    expect do
      post create_comment_path, params: valid_params
    end
    expect(response).to redirect_to(micropost_path(micropost.id))
  end
end

shared_examples 'when content is empty' do
  let(:invalid_params) { { content: '', parent_id: micropost.id } }

  it 'does not create a comment and renders the home page' do
    request.env['HTTP_REFERER'] = micropost_path(micropost.id)
    expect do
      post create_comment_path, params: invalid_params
    end
    expect(response).to redirect_to(micropost_path(micropost.id))
  end
end

shared_examples 'when parent_id is invalid' do
  let(:invalid_params) { { content: 'hinh2003', parent_id: 12 } }
  it 'does not create a comment and renders the home page' do
    request.env['HTTP_REFERER'] = micropost_path(micropost.id)
    expect do
      post create_comment_path, params: invalid_params
    end
  end
end
shared_examples 'destroy micropost' do

  it 'deletes the micropost and redirects to the index page' do
    expect do
      delete micropost_path(comment)
    end
  end
end
shared_examples 'update micropost' do
  context 'with valid params' do
    it 'updates the micropost and redirects to the show page' do
      put "/microposts/#{micropost.id}", params: { micropost: { content: 'Updated content' } }
      micropost.reload
      expect(micropost.content).to eq('Updated content')
      expect(response).to redirect_to(micropost_path(micropost))
    end
  end
  context 'with invalid params' do
    it 'does not update the micropost and re-renders the edit template' do
      put "/microposts/#{micropost.id}", params: { micropost: { content:'' } }
      expect(response).to render_template(:edit)
    end
  end
end
