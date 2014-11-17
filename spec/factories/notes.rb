FactoryGirl.define do
  factory :note do
    title { Faker::Name.name }
    level { :major }
    markdown_body { "*a note*" }
    project
  end
end
