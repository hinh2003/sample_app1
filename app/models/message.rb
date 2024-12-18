# frozen_string_literal: true

# this is model Message
class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room
  validates :content, presence: true, length: { maximum: 1000 }
  validates :content, presence: { message: "can't be blank" }
  validates :content, length: { maximum: 1000, message: 'is too long' }
end
