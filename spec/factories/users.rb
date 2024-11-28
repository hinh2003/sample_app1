# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { 'user@example.com' }
    password { 'password123' }
    name { 'John Doe' }
    uid { '12345' }
    provider { 'github' }
    activated { true }
  end
end
