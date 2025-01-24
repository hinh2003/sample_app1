# frozen_string_literal: true

# this is AddUniqueIndexToRoomsName
class AddUniqueIndexToRoomsName < ActiveRecord::Migration[6.1]
  def change
    add_index :rooms, :name, unique: true
  end
end
