require 'rails_helper'

RSpec.describe Api::ProjectsController, :type => :controller do
  let(:user) { FactoryGirl.create(:user) }

  before(:each) {
    sign_in(user)
    request.env["HTTP_ACCEPT"] = 'application/json'
  }

  describe "GET index" do
    let!(:project) { FactoryGirl.create(:project, user: user, team: user.team) }
    let!(:project2) { FactoryGirl.create(:project, user: user, team: user.team) }

    it "lists the projects" do
      get :index
      expect(response_json.count).to eq(2)
      expect(response_json.map{ |h| h["id"] }).to include(project.id, project2.id)
    end
  end

  describe "GET show" do
    let!(:project) { FactoryGirl.create(:project, user: user, team: user.team) }
    let!(:project2) { FactoryGirl.create(:project, user: user, team: user.team) }

    it "lists the project" do
      get :show, id: project.id
      expect(response_json["id"]).to eq(project.id)
    end
  end

  describe "POST create" do
    let(:params) { { title: "Test" } }

    it "creates a project" do
      expect {
        post :create, params
      }.to change{ user.projects.count }.by(1)
    end

    it "assigns title" do
      post :create, params
      expect(Project.last.title).to eq("Test")
    end

    context "with repos" do
      let(:rspec_stripe_repo) { YAML.load(File.read(Rails.root.join("spec", "fixtures", "rspec-stripe.yaml"))) }
      let(:angular_repo) { YAML.load(File.read(Rails.root.join("spec", "fixtures", "angular-tutorial.yaml"))) }

      before(:each) {
        allow_any_instance_of(RepositoryList).to receive(:repositories).and_return([ rspec_stripe_repo, angular_repo ])
      }

      it "creates repos" do
        expect {
          post :create, title: "Test", repos: ["sb8244/rspec-stripe"]
        }.to change{ Repository.count }.by(1)
        expect(Project.last.repositories.last.full_name).to eq("sb8244/rspec-stripe")
        expect(Project.last.repositories.last.private).to eq(false)
        expect(Project.last.repositories.last.url).to eq("https://github.com/sb8244/rspec-stripe")
        expect(Project.last.repositories.last.default_branch).to eq("master")
        expect(Project.last.repositories.last.github_id).to eq(24504509)
        expect(Project.last.repositories.last.owner).to eq("sb8244")
        expect(Project.last.repositories.last.repo).to eq("rspec-stripe")
      end
    end
  end

  describe "POST update" do
    let!(:project) { FactoryGirl.create(:project, user: user, team: user.team) }

    it "updates the project" do
      expect {
        post :update, title: "Test", id: project.id
      }.to change{ project.reload.title }.to eq("Test")
    end
  end

  describe "DELETE destroy" do
    let!(:project) { FactoryGirl.create(:project, user: user, team: user.team) }

    it "destroys the project" do
      expect {
        delete :destroy, id: project.id
      }.to change{ user.projects.count }.by(-1)
    end
  end
end
