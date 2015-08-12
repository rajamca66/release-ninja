FactoryGirl.define do
  factory :pull_request do
    github_id 1
    github_state 'open'
    title { 'test' }
    html_url { 'test' }
    github_user_name 'sb8244'
    body { 'test' }
    github_created_at { 1.day.ago }
    github_updated_at { Time.now }
  end
end
