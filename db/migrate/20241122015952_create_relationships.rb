# frozen_string_literal: true

# Migration to create the relationships table for users following each other.
# This table holds the follower and followed user IDs, which represent a
# many-to-many relationship between users. It allows tracking of who follows
# whom in the application.
class CreateRelationships < ActiveRecord::Migration[6.1]
  def change
    create_table :relationships do |t|
      t.integer :follower_id
      t.integer :followed_id
      t.timestamps
    end
    add_index :relationships, :follower_id
    add_index :relationships, :followed_id
    add_index :relationships, %i[follower_id followed_id], unique: true
  end
end
