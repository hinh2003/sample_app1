# frozen_string_literal: true

shared_examples 'GET /index' do
  it 'renders a successful response' do
    Message.create! valid_attributes
    get messages_url
    expect(response).to be_successful
  end
end

shared_examples 'GET /show' do
  it 'renders a successful response' do
    message = Message.create! valid_attributes
    get message_url(message)
    expect(response).to be_successful
  end
end

shared_examples 'GET /edit' do
  it 'renders a successful response' do
    message = Message.create! valid_attributes
    get edit_message_url(message)
    expect(response).to be_successful
  end
end

shared_examples 'POST /create' do
  context 'with valid parameters' do
    it 'creates a new Message' do
      expect do
        post messages_url, params: { message: valid_attributes }
      end.to change(Message, :count).by(1)
    end

    it 'redirects to the created message' do
      post messages_url, params: { message: valid_attributes }
      expect(response).to redirect_to(message_url(Message.last))
    end
  end

  context 'with invalid parameters' do
    it 'does not create a new Message' do
      expect do
        post messages_url, params: { message: invalid_attributes }
      end.to change(Message, :count).by(0)
    end

    it "renders a successful response (i.e. to display the 'new' template)" do
      post messages_url, params: { message: invalid_attributes }
      expect(response).to be_successful
    end
  end
end

shared_examples 'PATCH /update' do
  context 'with valid parameters' do
    let(:new_attributes) do
      skip('Add a hash of attributes valid for your model')
    end

    it 'updates the requested message' do
      message = Message.create! valid_attributes
      patch message_url(message), params: { message: new_attributes }
      message.reload
      skip('Add assertions for updated state')
    end

    it 'redirects to the message' do
      message = Message.create! valid_attributes
      patch message_url(message), params: { message: new_attributes }
      message.reload
      expect(response).to redirect_to(message_url(message))
    end
  end

  context 'with invalid parameters' do
    it "renders a successful response (i.e. to display the 'edit' template)" do
      message = Message.create! valid_attributes
      patch message_url(message), params: { message: invalid_attributes }
      expect(response).to be_successful
    end
  end
end

shared_examples 'DELETE /destroy' do
  it 'destroys the requested message' do
    message = Message.create! valid_attributes
    expect do
      delete message_url(message)
    end.to change(Message, :count).by(-1)
  end

  it 'redirects to the messages list' do
    message = Message.create! valid_attributes
    delete message_url(message)
    expect(response).to redirect_to(messages_url)
  end
end
