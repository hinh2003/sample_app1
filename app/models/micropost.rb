# frozen_string_literal: true

# The User model represents a user in the application.
# It is responsible for handling user authentication, registration,
# profile management, and other user-related functionality.
# This model is associated with several other models like `Post`, `Relationship`,
# and more. It uses features like secure password authentication and
# token generation for password resets.
class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  has_many :children,
           class_name: 'Micropost',
           foreign_key: 'parent_id',
           dependent: :destroy

  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validates :image, content_type: { in: %w[image/jpeg image/gif image/png],
                                    message: 'must be a valid image format' },
                    size: { less_than: 5.megabytes,
                            message: 'should be less than 5MB' }

  # Returns a resized image for display.
  def display_image
    image.variant(resize_to_limit: [500, 500])
  end

  def self.get_data(parent_id)
    sql = <<-SQL
    SELECT microposts.*,#{' '}
           (SELECT COUNT(*)#{' '}
            FROM microposts AS replies#{' '}
            WHERE replies.parent_id = microposts.id) AS reply_count
    FROM microposts
    WHERE microposts.parent_id = :parent_id
    SQL
    Micropost.find_by_sql([sql, { parent_id: parent_id }])
  end
end
