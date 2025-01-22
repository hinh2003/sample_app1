# frozen_string_literal: true

# this is MessagesController
class MessagesController < ApplicationController
  before_action :set_message, :logged_in?, only: %i[show edit update destroy]

  def index
    @messages = Message.all
  end

  def show; end
  def update_message; end

  def new
    @message = Message.new
  end

  def edit
    set_message
    render 'form_update'
  end

  def create
    @message = Message.new(message_params)
    @message.user_id = current_user.id

    if @message.save
      mine, theirs = render_message_partials(@message)
      broadcast_message(@message.room_id, mine, theirs, @message)
    else
      flash.now[:info] = 'Something went wrong'
      redirect_to root_url
    end
  end

  def update
    set_message
    room_id = @message.room_id
    message_params = message_update.merge(edited: true)

    return unless @message.update(message_params)

    mine, theirs = render_message_partials(@message)
    broadcast_message_update(room_id, @message, mine, theirs)
  end

  def destroy
    set_message
    room_id = @message.room_id
    message_id = @message.id
    @message.destroy
    broadcast_message_deletion(room_id, message_id)
  end

  private

  def render_message_partials(message)
    mine = ApplicationController.render(
      partial: 'messages/mine',
      locals: { message: message }
    )

    theirs = ApplicationController.render(
      partial: 'messages/theirs',
      locals: { message: message }
    )

    [mine, theirs]
  end

  def broadcast_message(room_id, mine, theirs, message)
    ActionCable.server.broadcast(
      "room_channel_#{room_id}",
      {
        mine: mine,
        theirs: theirs,
        message: message.slice(:id, :content, :user_id, :room_id),
        action: 'create'
      }
    )
    head :ok
  end

  def broadcast_message_deletion(room_id, message_id)
    ActionCable.server.broadcast(
      "room_channel_#{room_id}",
      {
        action: 'delete_message',
        message_id: message_id
      }
    )
  end

  def broadcast_message_update(room_id, message, mine, theirs)
    ActionCable.server.broadcast(
      "room_channel_#{room_id}",
      {
        action: 'update_message',
        message: message.slice(:id, :content, :user_id, :room_id),
        mine: mine,
        theirs: theirs
      }
    )
  end

  def set_message
    @message = Message.find(params[:id])
  end

  def message_params
    params.require(:message).permit(:content, :user_id, :room_id)
  end

  def message_update
    params.require(:message).permit(:content)
  end
end
