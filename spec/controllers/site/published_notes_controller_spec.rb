require "rails_helper"

RSpec.describe Site::PublishedNotesController, type: :controller do
  let!(:project) { FactoryGirl.create(:project) }

  describe "GET index" do
    let!(:published_notes) { FactoryGirl.create_list(:note, 3, project: project, published: true) }
    let!(:unpublished_notes) { FactoryGirl.create_list(:note, 4, project: project) }

    subject(:make_request!) { get :index, site_id: project.id }

    it "is successful" do
      make_request!
      expect(response).to be_success
    end

    it "returns published notes" do
      make_request!
      expect(response_json.length).to eq(3)
    end

    it "returns desired fields" do
      make_request!
      expect(response_json[0].keys).to match_array(["id", "published_at", "html_title", "html_body"])
    end

    context "with large pages" do
      let!(:published_notes) { FactoryGirl.create_list(:note, 30, project: project, published: true) }

      it "pages the request" do
        make_request!
        expect(response_json.length).to eq(10)
        expect(response_json[0]["id"]).to eq(published_notes.last.id)
      end

      it "pages the request" do
        get :index, site_id: project.id, page: 2
        expect(response_json.length).to eq(10)
        expect(response_json[0]["id"]).to eq(published_notes[19].id)
      end
    end

    context "with a user_key" do
      subject(:make_request!) { get :index, site_id: project.id, user_key: "steve" }

      it "creates a new UserReadingLocation" do
        expect {
          make_request!
        }.to change { project.user_reading_locations.count }.by(1)
      end

      it "uses an existing UserReadingLocation" do
        project.user_reading_locations.create!(user_key: "steve", reading_location: Time.current)
        expect {
          make_request!
        }.not_to change { project.user_reading_locations.count }
      end

      it "sets reading_location" do
        make_request!
        expect(UserReadingLocation.last.reading_location).to eq(published_notes.last.published_at)
      end

      it "uses the current  time if published_at is nil" do
        Note.update_all(published_at: nil)
        make_request!
        expect(UserReadingLocation.last.reading_location).to be_within(2).of(Time.current)
      end

      context "with a reading_location > published_at" do
        let!(:time) { 5.days.from_now }
        let!(:reading_location) { project.user_reading_locations.create!(user_key: "steve", reading_location: time) }

        it "doesn't update the reading_location" do
          expect {
            make_request!
          }.not_to change { reading_location.reload.attributes }
        end
      end

      context "with a reading_location < published_at" do
        let!(:time) { 5.minutes.ago }
        before { Note.update_all(published_at: 4.minutes.ago) }
        let!(:reading_location) { project.user_reading_locations.create!(user_key: "steve", reading_location: time) }

        it "updates the reading_location" do
          expect {
            make_request!
          }.to change { reading_location.reload.reading_location }.to be_within(2).of(4.minutes.ago)
        end
      end
    end
  end
end
