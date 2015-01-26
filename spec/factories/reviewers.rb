FactoryGirl.define do
  factory :reviewer do
    email { Faker::Internet.email }
    name { Faker::Name.name }
  end
end
