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
end
