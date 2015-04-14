FactoryGirl.define do
  factory :customer_know, class: Repository do
    project
    full_name "salesloft/release-ninja"
    user
    private { true }
    url "https://github.com/salesloft/release-ninja"
    default_branch "master"
    github_id 26443195
    owner "salesloft"
    repo "release-ninja"
  end
end
