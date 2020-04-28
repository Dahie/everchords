# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email     { Faker::Internet.email }
    username  { Faker::Name.first_name }
    password  { 'password' }
    password_confirmation { 'password' }
    provider { 'evernote' }
  end
end
