require 'rails_helper'

RSpec.describe RepositoryList do
  let!(:user) { FactoryGirl.create(:github_user) }
  before(:each) { Rails.cache.clear }

  subject { RepositoryList.new(user) }

  # These are names of your repos that are both private and public. This will
  # be used to verify the code works. It isn't optimal but is easier than stubbing
  # out all HTTP requests
  let(:your_repos) { YAML.load(File.read( Rails.root.join("spec", "fixtures", "your_repos.private.yaml"))) }

  it "gives visibility to all repos", vcr: { cassette_name: "private/repository-list-1" } do
    if File.exist?("spec/cassettes/private/repository-list-1.yml") # This is blocking CI because I'm not putting my private data on it
      expect(subject.repositories.map(&:full_name)).to include(*your_repos
    end
  end
end
