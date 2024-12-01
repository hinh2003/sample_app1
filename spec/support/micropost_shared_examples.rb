shared_examples 'with valid params' do
  let(:valid_params) { { content: 'A new comment', parent_id: micropost.id } }

  it 'creates a new comment and redirects to the referer' do
    expect do
      post create_comment_path, params: valid_params
    end
    expect(response).to redirect_to(referer)
  end
end
shared_examples 'when content is empty' do
  let(:invalid_params) { { content: '', parent_id: micropost.id } }

  it 'does not create a comment and renders the home page' do
    expect do
      post create_comment_path, params: invalid_params
    end
    expect(response).to redirect_to(root_url)
  end
end

shared_examples 'when parent_id is invalid' do
  let(:invalid_params) { { content: 'hinh2003', parent_id: 12 } }

  it 'does not create a comment and renders the home page' do
    expect do
      post create_comment_path, params: invalid_params
    end
    expect(response).to redirect_to(root_url)
  end
end
