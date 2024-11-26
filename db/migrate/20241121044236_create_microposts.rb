# frozen_string_literal: true

# Migration to create the relationships table for users following each other.
# This table holds the follower and followed user IDs, which represent a
# many-to-many relationship between users. It allows tracking of who follows
# whom in the application.
class CreateMicroposts < ActiveRecord::Migration[6.1]
  def change
    create_table :microposts do |t|
      t.text :content
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    add_index :microposts, %i[user_id created_at]
  end
end
