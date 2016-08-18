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
      expect(response_json["notes"].length).to eq(3)
    end

    it "returns desired fields" do
      make_request!
      expect(response_json["notes"][0].keys).to match_array(["id", "published_at", "html_title", "html_body", "level"])
    end

    context "with large pages" do
      let!(:published_notes) { FactoryGirl.create_list(:note, 30, project: project, published: true) }

      it "pages the request" do
        make_request!
        expect(response_json["meta"]["total_count"]).to eq(30)
        expect(response_json["meta"]["page"]).to eq(1)
        expect(response_json["meta"]["total_pages"]).to eq(3)
        expect(response_json["notes"].length).to eq(10)
        expect(response_json["notes"][0]["id"]).to eq(published_notes.last.id)
      end

      it "pages the request" do
        get :index, site_id: project.id, page: 2
        expect(response_json["notes"].length).to eq(10)
        expect(response_json["notes"][0]["id"]).to eq(published_notes[19].id)
      end
    end

    context "with a user_key" do
      subject(:make_request!) { get :index, site_id: project.id, user_key: "steve" }
      let!(:project2) { FactoryGirl.create(:project) }
      let!(:reading_location) { project2.user_reading_locations.create!(user_key: "steve", reading_location: 5.minutes.from_now) }

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

      it "doesn't render notes if published_at is nil" do
        Note.update_all(published_at: nil)
        make_request!
        expect(response).to be_success
        expect(response_json["notes"]).to eq([])
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

  describe "GET unread" do
    let!(:published_notes) { FactoryGirl.create_list(:note, 3, project: project, published: true) }
    let!(:unpublished_notes) { FactoryGirl.create_list(:note, 4, project: project) }
    let!(:reading_location) { project.user_reading_locations.create!(user_key: "steve", reading_location: 5.seconds.ago) }

    context "without a UserReadingLocation" do
      it "renders count of all published notes" do
        get :unread, site_id: project.id, user_key: "test"
        expect(response_json["unread"]).to eq(published_notes.count)
      end

      it "renders count of all published notes" do
        get :unread, site_id: project.id
        expect(response_json["unread"]).to eq(published_notes.count)
      end
    end

    context "with a UserReadingLocation" do
      it "renders the count of notes later than reading_location" do
        published_notes[0].update!(published_at: 5.minutes.ago)
        get :unread, site_id: project.id, user_key: "steve"
        expect(response_json["unread"]).to eq(2)
      end

      it "renders the count of notes later than reading_location" do
        Note.update_all(published_at: 5.minutes.ago)
        get :unread, site_id: project.id, user_key: "steve"
        expect(response_json["unread"]).to eq(0)
      end
    end
  end
end
