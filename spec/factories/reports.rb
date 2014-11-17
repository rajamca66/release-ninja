FactoryGirl.define do
  factory :report do
    name { Faker::Name.name }
    project
  end
end
