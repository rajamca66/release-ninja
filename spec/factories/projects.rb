FactoryGirl.define do
  factory :project do
    title { Faker::Name.name }
    user
  end
end
