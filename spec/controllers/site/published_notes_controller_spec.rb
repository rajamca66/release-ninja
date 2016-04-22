require "rails_helper"

RSpec.describe Site::PublishedNotesController, type: :controller do
  let!(:project) { FactoryGirl.create(:project) }

  describe "GET index" do
    let!(:published_notes) { FactoryGirl.create_list(:note, 3, project: project, published: true) }
    let!(:unpublished_notes) { FactoryGirl.create_list(:note, 4, project: project) }

    it "is successful" do
      get :index, site_id: project.id
      expect(response).to be_success
    end

    it "returns published notes" do
      get :index, site_id: project.id
      expect(response_json.length).to eq(3)
    end

    it "returns desired fields" do
      get :index, site_id: project.id
      expect(response_json[0].keys).to match_array(["id", "published_at", "html_title", "html_body"])
    end

    context "with large pages" do
      let!(:published_notes) { FactoryGirl.create_list(:note, 30, project: project, published: true) }

      it "pages the request" do
        get :index, site_id: project.id
        expect(response_json.length).to eq(10)
        expect(response_json[0]["id"]).to eq(published_notes.last.id)
      end

      it "pages the request" do
        get :index, site_id: project.id, page: 2
        expect(response_json.length).to eq(10)
        expect(response_json[0]["id"]).to eq(published_notes[19].id)
      end
    end
  end
end
