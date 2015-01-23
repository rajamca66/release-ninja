FactoryGirl.define do
  factory :customer_know, class: Repository do
    project
    full_name "sb8244/CustomerKnow"
    user
    private { true }
    url "https://github.com/sb8244/CustomerKnow"
    default_branch "master"
    github_id 26443195
    owner "sb8244"
    repo "CustomerKnow"
  end
end
