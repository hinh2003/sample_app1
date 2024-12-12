# frozen_string_literal: true

# this is model room
class Room < ApplicationRecord
  has_many :messages, dependent: :destroy

  def self.find_room(user_id, recipient_id)
    Room.joins(messages: :user)
        .where(messages: { user_id: user_id })
        .joins('INNER JOIN messages m2 ON rooms.id = m2.room_id')
        .where('m2.user_id = ?', recipient_id)
        .distinct.first
  end
end
