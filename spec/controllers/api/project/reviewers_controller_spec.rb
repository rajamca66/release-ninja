require 'rails_helper'

RSpec.describe Api::Project::ReviewersController, :type => :controller do
  let(:user) { FactoryGirl.create(:github_user) }
  let!(:project) { FactoryGirl.create(:project, user: user, team: user.team) }

  before(:each) {
    sign_in(user)
    request.env["HTTP_ACCEPT"] = 'application/json'
  }

  describe "GET index" do
    let!(:reviewer1) { FactoryGirl.create(:reviewer) }
    let!(:reviewer2) { FactoryGirl.create(:reviewer) }
    let!(:reviewer3) { FactoryGirl.create(:reviewer) }

    before(:each) {
      reviewer1.projects << project
      reviewer2.projects << project
    }

    it "lists the reviewers" do
      get :index, project_id: project.id
      expect(response_json.count).to eq(2)
    end
  end

  describe "POST create" do
    context "a new reviewer" do
      it "creates a reviewer" do
        expect {
          post :create, project_id: project.id, email: "test@test.com"
        }.to change{ Reviewer.count }.by(1)
      end

      it "adds the reviewer to the project" do
        post :create, project_id: project.id, email: "test@test.com"
        expect(Reviewer.last.projects).to include(project)
      end
    end

    context "existing reviewer" do
      let!(:reviewer1) { FactoryGirl.create(:reviewer) }

      it "doesn't create a reviewer" do
        expect {
          post :create, project_id: project.id, email: reviewer1.email
        }.not_to change{ Reviewer.count }
      end

      it "adds the reviewer to the project" do
        post :create, project_id: project.id, email: reviewer1.email
        expect(reviewer1.projects).to include(project)
      end
    end
  end

  describe "DELETE destroy" do
    let!(:reviewer1) { FactoryGirl.create(:reviewer) }
    let!(:reviewer2) { FactoryGirl.create(:reviewer) }
    let!(:reviewer3) { FactoryGirl.create(:reviewer) }

    before(:each) {
      reviewer1.projects << project
      reviewer2.projects << project
    }

    it "removes the reviewer from the project" do
      expect {
        expect {
          delete :destroy, project_id: project.id, id: reviewer1.id
        }.not_to change{ Reviewer.find(reviewer1.id) }
      }.to change{ project.reviewers.include?(reviewer1) }.from(true).to(false)
    end
  end
end
