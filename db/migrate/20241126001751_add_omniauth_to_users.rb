# frozen_string_literal: true

# Migration to add provider and uid columns to users table
class AddOmniauthToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :provider, :string
    add_column :users, :uid, :string
  end
end
