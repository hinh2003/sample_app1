# frozen_string_literal: true

# Migration to add parent_id to microposts
# This table holds the follower and followed user IDs, which represent a
# many-to-many relationship between users. It allows tracking of who follows
# whom in the application.
class AddParentIdToMicropost < ActiveRecord::Migration[6.1]
  def change
    add_column :microposts, :parent_id, :integer
  end
  add_index :microposts, :content
end
