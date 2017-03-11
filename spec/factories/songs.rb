# == Schema Information
#
# Table name: songs
#
#  id           :integer          not null, primary key
#  title        :string
#  body         :text
#  user_id      :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  guid         :string
#  published    :string           default("f")
#  secret_token :string
#

FactoryGirl.define do
  factory :song do
    title         { Faker::Lorem.sentence }
    body          { Faker::Lorem.paragraphs.join('<br>') }
    user
    guid          { SecureRandom.uuid }
    secret_token  { Devise.friendly_token.first(8) }
  end
end
