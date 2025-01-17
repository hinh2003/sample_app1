# frozen_string_literal: true

# this is  CreateMessages
class CreateMessages < ActiveRecord::Migration[6.1]
  def change
    create_table :messages do |t|
      t.text :content
      t.references :user, null: false, foreign_key: true
      t.references :room, null: false, foreign_key: true
      t.boolean :edited, default: false

      t.timestamps
    end
  end
end
