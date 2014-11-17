require 'spec_helper'

RSpec.describe Api::ReportsController, type: :controller do
  let(:user) { FactoryGirl.create(:user) }
  let!(:project) { FactoryGirl.create(:project, user: user) }

  before(:each) {
    sign_in(user)
    request.env["HTTP_ACCEPT"] = 'application/json'
  }

  describe "index" do
    let!(:report) { FactoryGirl.create(:report, project: project) }

    it "lists the reports" do
      get :index, project_id: project.id
      expect(response_json.count).to eq(1)
      expect(response_json.first["name"]).to eq(report.name)
    end
  end

  describe "show" do
    let!(:report) { FactoryGirl.create(:report, project: project) }

    it "has the report" do
      get :show, id: report.id, project_id: project.id
      expect(response_json["id"]).to eq(report.id)
      expect(response_json["name"]).to eq(report.name)
      expect(response_json["notes"]).to eq([])
    end
  end

  describe "update" do
    let!(:report) { FactoryGirl.create(:report, project: project) }

    it "updates the report name" do
      expect {
        post :update, id: report.id, project_id: project.id, name: "new name"
      }.to change{ report.reload.name }.to("new name")
    end
  end

  describe "create" do
    it "creates a new report" do
      expect {
        post :create, project_id: project.id, name: "new name"
      }.to change{ project.reports.count }.by(1)
    end
  end

  describe "delete" do
    let!(:report) { FactoryGirl.create(:report, project: project) }

    it "removes the report" do
      expect {
        delete :destroy, id: report.id, project_id: project.id
      }.to change{ project.reports.count }.by(-1)
    end
  end

  describe "add_note" do
    let!(:report) { FactoryGirl.create(:report, project: project) }
    let!(:note) { FactoryGirl.create(:note, project: project) }

    it "adds the note to the report" do
      expect {
        post :add_note, id: report.id, project_id: project.id, note_id: note.id
      }.to change{ report.notes.count }.by(1)
    end

    it "can't double add a note" do
      report.notes << note
      expect {
        post :add_note, id: report.id, project_id: project.id, note_id: note.id
      }.not_to change{ report.notes.count }
      expect(response).to be_success
    end
  end

  describe "remove_note" do
    let!(:report) { FactoryGirl.create(:report, project: project) }
    let!(:note) { FactoryGirl.create(:note, project: project) }

    before(:each) { report.notes << note }

    it "removes the note" do
      expect {
        delete :remove_note, id: report.id, project_id: project.id, note_id: note.id
      }.to change{ report.notes.count }.by(-1)
    end
  end
end
