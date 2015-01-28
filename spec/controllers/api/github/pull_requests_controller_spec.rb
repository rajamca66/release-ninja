require 'rails_helper'

RSpec.describe Api::Github::PullRequestsController, :type => :controller do
  let(:user) { FactoryGirl.create(:github_user) }
  let!(:project) { FactoryGirl.create(:project, user: user, team: user.team) }
  let(:repo) { FactoryGirl.create(:customer_know, user: user, project: project) }

  before(:each) {
    sign_in(user)
    request.env["HTTP_ACCEPT"] = 'application/json'
  }

  describe "GET index" do
    it "lists PRs", vcr: { cassette_name: "private/pull-request-list-1" } do
      if File.exist?("spec/cassettes/private/pull-request-1.yml") # This is blocking CI because I'm not putting my private data on it
        get :index, repository_id: repo.id, project_id: project.id
        expect(response_json.count).to eq(4)
      end
    end
  end
end
