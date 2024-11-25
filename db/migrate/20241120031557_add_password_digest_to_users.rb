# frozen_string_literal: true

# Migration to create the relationships table for users following each other.
# This table holds the follower and followed user IDs, which represent a
# many-to-many relationship between users. It allows tracking of who follows
# whom in the application.
class AddPasswordDigestToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :password_digest, :string
  end
end
