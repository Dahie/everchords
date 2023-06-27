# frozen_string_literal: true

FactoryBot.define do
  factory :notebook do
    name { Faker::Name.first_name }
    user
  end
end
