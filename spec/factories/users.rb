FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    name { Faker::Name.name }
    nickname { Faker::Name.name }
    team

    factory :github_user do
      github_token { ENV.fetch("GITHUB_TEST_TOKEN", "test_token") }
    end
  end
end
