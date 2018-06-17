FactoryGirl.define do
  factory :notebook do
    name { Faker::Name.first_name }
  end
end
