# frozen_string_literal: true

# factories/microposts.rb

FactoryBot.define do
  factory :micropost do
    content { Faker::Lorem.sentence }
    user
    parent_id { nil }
    trait :comment do
      parent_id { create(:micropost).id }
    end
  end
end
