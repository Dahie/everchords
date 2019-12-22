# frozen_string_literal: true

FactoryBot.define do
  factory :song do
    title         { Faker::Lorem.sentence }
    body          { Faker::Lorem.paragraphs.join('<br>') }
    association   :notebook
    association   :user
    guid          { SecureRandom.uuid }
    secret_token  { Devise.friendly_token.first(8) }
  end
end
