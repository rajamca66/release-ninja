require 'rails_helper'

RSpec.describe Api::NotesController, type: :controller do
  let(:user) { FactoryGirl.create(:github_user) }
  let(:team) { user.team }
  let!(:project) { FactoryGirl.create(:project, user: user, team: team) }

  before(:each) {
    sign_in(user)
    request.env["HTTP_ACCEPT"] = 'application/json'
  }

  describe "GET index" do
    let!(:github_note)  { FactoryGirl.create(:note, project: project, filter: "github") }
    let!(:github_note2) { FactoryGirl.create(:note, project: project, filter: "github") }
    let!(:product_note) { FactoryGirl.create(:note, project: project, filter: "product") }
    let!(:published_note) { FactoryGirl.create(:note, project: project, published: true) }
    let!(:other) { FactoryGirl.create(:note, project: FactoryGirl.create(:project)) }

    it "lists all notes" do
      get :index, project_id: project.id
      expect(response_json.length).to eq(4)
    end

    it "lists github notes" do
      get :index, project_id: project.id, filter: "github"
      expect(response_json.length).to eq(2)
      expect(response_json[0]["id"]).to eq(github_note2.id)
    end

    it "lists product notes" do
      get :index, project_id: project.id, filter: "product"
      expect(response_json.length).to eq(1)
      expect(response_json[0]["id"]).to eq(product_note.id)
    end

    it "lists published notes" do
      get :index, project_id: project.id, filter: "published"
      expect(response_json.length).to eq(1)
      expect(response_json[0]["id"]).to eq(published_note.id)
    end
  end

  describe "PUT update" do
    let!(:note) { FactoryGirl.create(:note, project: project) }

    it "updates the note" do
      expect {
        put :update, project_id: project.id, id: note.id, title: "New"
      }.to change{ note.reload.title }.to("New")
    end

    it "updates the published_at time using db format" do
      expect {
        put :update, project_id: project.id, id: note.id, published_at: "2015-02-24 14:23:35"
      }.to change{ note.reload.published_at.try!(:to_s, :db) }.to("2015-02-24 14:23:35")
    end

    ["github", "product"].each do |filter|
      it "updates the filter #{filter}" do
        note.update!(filter: "test")
        expect {
          put :update, project_id: project.id, id: note.id, filter: filter
        }.to change{ note.reload.filter }.to eq(filter)
      end
    end
  end

  describe "POST team_emails" do
    let!(:note) { FactoryGirl.create(:note, project: project) }
    let!(:r1)   { FactoryGirl.create(:reviewer) }
    let!(:r2)   { FactoryGirl.create(:reviewer) }

    before(:each) {
      project.reviewers << r1
      project.reviewers << r2
      ActionMailer::Base.deliveries.clear
    }

    it "returns emails addressess" do
      post :team_emails, project_id: project.id, id: note.id
      expect(response_json).to eq([r1.email, r2.email])
    end

    it "succeeds" do
      post :team_emails, project_id: project.id, id: note.id
      expect(response.code).to eq("200")
    end

    it "sends emails to team members" do
      expect {
        post :team_emails, project_id: project.id, id: note.id
      }.to change{ ActionMailer::Base.deliveries.count }.by(2)

      expect(ActionMailer::Base.deliveries.first.to).to eq([r1.email])
      expect(ActionMailer::Base.deliveries.last.to).to eq([r2.email])
    end
  end
end
