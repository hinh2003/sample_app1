# frozen_string_literal: true

# this is RoomsController
class RoomsController < ApplicationController
  before_action :set_room, only: %i[show edit update destroy]

  def index
    room_ids = Message.where(user_id: current_user.id).pluck(:room_id).uniq
    @rooms = Room.where(id: room_ids).or(Room.where(public: 1))
  end

  def show
    room_ids = Message.where(user_id: current_user.id).pluck(:room_id).uniq
    @rooms = Room.where(id: room_ids).or(Room.where(public: 1))
    render 'index'
  end

  def new
    @room = Room.new
  end

  def edit; end

  def create
    room_data = room_params.merge(public: true)
    @room = Room.new(room_data)

    respond_to do |format|
      if @room.save
        format.html { redirect_to @room, notice: 'Room was successfully created.' }
        format.json { render :show, status: :created, location: @room }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @room.update(room_params)
        format.html { redirect_to @room, notice: 'Room was successfully updated.' }
        format.json { render :show, status: :ok, location: @room }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @room.destroy

    respond_to do |format|
      format.html { redirect_to rooms_path, status: :see_other, notice: 'Room was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def create_room
    recipient = User.find(params[:recipient_id])
    existing_message = Room.find_room(current_user.id, recipient.id)

    if existing_message
      redirect_to room_path(existing_message.id)
    else
      @room = create_new_room(current_user, recipient)

      if @room.save
        send_welcome_messages(@room)
        redirect_to room_path(@room)
      end
    end
  end

  private

  def set_room
    @room = Room.find(params[:id])
  end

  def room_params
    params.require(:room).permit(:name)
  end

  def find_existing_room(user_id, recipient_id)
    Room.find_room(user_id, recipient_id)
  end

  def create_new_room(current_user, recipient)
    Room.new(name: "#{current_user.name} - #{recipient.name}")
  end

  def send_welcome_messages(room)
    Message.create(user_id: current_user.id, room_id: room.id, content: "welcome to #{room.name}")
    Message.create(user_id: recipient.id, room_id: room.id, content: "welcome to #{room.name}")
  end
end
