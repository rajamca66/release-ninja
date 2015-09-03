require 'rails_helper'

RSpec.describe Api::NotesController, :type => :controller do
  let(:user) { FactoryGirl.create(:github_user) }
  let(:team) { user.team }
  let!(:project) { FactoryGirl.create(:project, user: user, team: team) }

  before(:each) {
    sign_in(user)
    request.env["HTTP_ACCEPT"] = 'application/json'
  }

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
