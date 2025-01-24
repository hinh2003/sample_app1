# frozen_string_literal: true

shared_examples 'GET /index' do
  it 'renders a successful response' do
    Room.create! valid_attributes
    get rooms_url
    expect(response).to be_successful
  end
end

shared_examples 'GET /show' do
  it 'renders a successful response' do
    room = Room.create! valid_attributes
    get room_url(room)
    expect(response).to be_successful
  end
end

shared_examples 'GET /new' do
  it 'renders a successful response' do
    get new_room_url
    expect(response).to be_successful
  end
end

shared_examples 'GET /edit' do
  it 'renders a successful response' do
    room = Room.create! valid_attributes
    get edit_room_url(room)
    expect(response).to be_successful
  end
end

shared_examples 'POST /create' do
  context 'with valid parameters' do
    it 'creates a new Room' do
      expect do
        post rooms_url, params: { room: valid_attributes }
      end.to change(Room, :count).by(1)
    end

    it 'redirects to the created room' do
      post rooms_url, params: { room: valid_attributes }
      expect(response).to redirect_to(room_url(Room.last))
    end
  end

  context 'with invalid parameters' do
    it 'does not create a new Room' do
      expect do
        post rooms_url, params: { room: invalid_attributes }
      end.to change(Room, :count).by(0)
    end

    it "renders a successful response (i.e. to display the 'new' template)" do
      post rooms_url, params: { room: invalid_attributes }
      expect(response).to be_successful
    end
  end
end

shared_examples 'PATCH /update' do
  context 'with valid parameters' do
    let(:new_attributes) do
      skip('Add a hash of attributes valid for your model')
    end

    it 'updates the requested room' do
      room = Room.create! valid_attributes
      patch room_url(room), params: { room: new_attributes }
      room.reload
      skip('Add assertions for updated state')
    end

    it 'redirects to the room' do
      room = Room.create! valid_attributes
      patch room_url(room), params: { room: new_attributes }
      room.reload
      expect(response).to redirect_to(room_url(room))
    end
  end

  context 'with invalid parameters' do
    it "renders a successful response (i.e. to display the 'edit' template)" do
      room = Room.create! valid_attributes
      patch room_url(room), params: { room: invalid_attributes }
      expect(response).to be_successful
    end
  end
end

shared_examples 'DELETE /destroy' do
  it 'destroys the requested room' do
    room = Room.create! valid_attributes
    expect do
      delete room_url(room)
    end.to change(Room, :count).by(-1)
  end

  it 'redirects to the rooms list' do
    room = Room.create! valid_attributes
    delete room_url(room)
    expect(response).to redirect_to(rooms_url)
  end
end
