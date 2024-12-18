# frozen_string_literal: true
# frozen_string_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literal: true

# this is model room
class Room < ApplicationRecord
  has_many :messages, dependent: :destroy

  validates :name, presence: true, uniqueness: true

  def self.find_room(user_id, recipient_id)
    Room.joins(messages: :user)
        .where(messages: { user_id: user_id })
        .joins('INNER JOIN messages m2 ON rooms.id = m2.room_id')
        .where('m2.user_id = ?', recipient_id)
        .distinct.first
  end
end
