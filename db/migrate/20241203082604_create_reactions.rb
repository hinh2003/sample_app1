# frozen_string_literal: true

# this is migration create table reaction
class CreateReactions < ActiveRecord::Migration[6.1]
  def change
    create_table :reactions do |t|
      t.integer :user_id, null: false
      t.integer :micropost_id, null: false
      t.integer :reaction_type, null: false

      t.timestamps
    end
    add_index :reactions, %i[user_id micropost_id], unique: true
  end
end
