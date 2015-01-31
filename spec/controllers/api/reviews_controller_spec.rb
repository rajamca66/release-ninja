require 'rails_helper'

RSpec.describe Api::ReviewsController, :type => :controller do
  let(:user) { FactoryGirl.create(:github_user) }
  let!(:project) { FactoryGirl.create(:project, user: user, team: user.team) }
  let!(:repository) { FactoryGirl.create(:customer_know, project: project) }

  before(:each) {
    sign_in(user)
    request.env["HTTP_ACCEPT"] = 'application/json'
  }

  describe "POST create" do
    it "creates a note", vcr: { cassette_name: "reviews-controller_create-note"  } do
      expect {
        post :create, pull_request_id: 6, repository_id: repository.id, project_id: project.id
      }.to change{ project.notes.count }.by(1)

      expect(response_json).to include("message")
    end

    context "with reviewers" do
      let!(:r1) { FactoryGirl.create(:reviewer) }
      let!(:r2) { FactoryGirl.create(:reviewer) }

      before(:each) {
        project.reviewers << r1
        project.reviewers << r2
      }

      it "sends out emails", vcr: { cassette_name: "reviews-controller_create-note" } do
        expect {
          post :create, pull_request_id: 6, repository_id: repository.id, project_id: project.id
        }.to change{ ActionMailer::Base.deliveries.count }.by(2)
        expect(ActionMailer::Base.deliveries.last.to).to eq([r2.email])
      end

      context "with a user who wrote it", vcr: { cassette_name: "reviews-controller_create-note" } do
        before(:each) { user.update!(nickname: "sb8244") }

        it "sends them an email" do
          post :create, pull_request_id: 6, repository_id: repository.id, project_id: project.id
          expect(ActionMailer::Base.deliveries.last.to).to match_array([r2.email, user.email])
        end
      end

      context "with a converted pull request" do
        let!(:note) { FactoryGirl.create(:note, project: project) }
        let!(:converted) { project.converted_pull_requests.create!(note: note, pull_request_id: 28002510) }

        it "removes the old note", vcr: { cassette_name: "reviews-controller_with-old-note"  } do
          expect {
            post :create, pull_request_id: 6, repository_id: repository.id, project_id: project.id
          }.to change{ Note.find_by(id: note.id) }.from(note).to(nil)
        end

        it "creates a note", vcr: { cassette_name: "reviews-controller_with-old-note"  } do
          expect {
            expect {
              post :create, pull_request_id: 6, repository_id: repository.id, project_id: project.id
            }.not_to change{ project.notes.count }
          }.to change{ project.notes.last }
        end
      end
    end
  end
end
