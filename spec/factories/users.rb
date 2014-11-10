FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    name { Faker::Name.name }
    nickname { Faker::Name.name }

    factory :github_user do
      github_token { ENV["GITHUB_TEST_TOKEN"] }
    end
  end
end
