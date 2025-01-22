# frozen_string_literal: true

# The User model represents a user in the application.
# It is responsible for handling user authentication, registration,
# profile management, and other user-related functionality.
# This model is associated with several other models like `Post`, `Relationship`,
# and more. It uses features like secure password authentication and
# token generation for password resets.
class Micropost < ApplicationRecord
  belongs_to :user
  has_many :reactions, dependent: :destroy
  has_one_attached :image
  has_many :replies,
           class_name: 'Micropost',
           foreign_key: 'parent_id',
           dependent: :destroy,
           inverse_of: :parent

  belongs_to :parent,
             class_name: 'Micropost',
             optional: true,
             inverse_of: :replies

  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validates :image, content_type: { in: %w[image/jpeg image/gif image/png],
                                    message: 'must be a valid image format' },
                    size: { less_than: 5.megabytes,
                            message: 'should be less than 5MB' }
  scope :new_posts_yesterday, lambda { |date|
    where(created_at: date.beginning_of_day..date.end_of_day)
      .where(parent_id: nil)
  }

  scope :new_comments_yesterday, lambda { |date|
    where(created_at: date.beginning_of_day..date.end_of_day)
      .where.not(parent_id: nil)
  }

  scope :most_commented_yesterday, ->(date) {
    where(created_at: date.beginning_of_day..date.end_of_day)
      .where.not(parent_id: nil)
      .group(:parent_id)
      .order('count_all DESC')
      .count
  }
  # Returns a resized image for display.
  def display_image
    image.variant(resize_to_fit: [500, 500])
  end
end
