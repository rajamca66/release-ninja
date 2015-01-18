FactoryGirl.define do
  factory :note do
    title { Faker::Name.name }
    level { :major }
    markdown_body { "*" + Faker::Lorem.paragraph + "*" }
    project
  end
end
