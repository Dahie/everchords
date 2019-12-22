FactoryBot.define do
  factory :notebook do
    name { Faker::Name.first_name }
    association   :user
  end
end
