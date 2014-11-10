FactoryGirl.define do
  factory :github_user, class: User do
    email { Faker::Internet.email }
    name { Faker::Name.name }
    nickname { Faker::Name.name }
    github_token { ENV["GITHUB_TEST_TOKEN"] }
  end
end
