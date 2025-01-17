# frozen_string_literal: true

# this is CreateRooms
class CreateRooms < ActiveRecord::Migration[6.1]
  def change
    create_table :rooms do |t|
      t.string :name
      t.boolean :public, null: false, default: false

      t.timestamps
    end
  end
end
