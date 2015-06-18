require 'rails_helper'

RSpec.describe HooksController, :type => :controller do
  let(:user) { FactoryGirl.create(:github_user) }
  let(:team) { user.team }
  let!(:project) { FactoryGirl.create(:project, user: user, team: user.team) }
  let!(:repository) { FactoryGirl.create(:customer_know, project: project) }

  let(:hook_params) { { project_id: project.id, repository_id: repository.id } }

  before(:each) {
    request.env["HTTP_ACCEPT"] = "*/*"
    request.env["CONTENT_TYPE"] = "application/json"
  }

  describe "merged" do
    let(:params) { JSON.parse(File.read("spec/fixtures/github_hooks/merged.json")) }

    it "creates a converted pull request", vcr: { cassette_name: "hooks-controller_merged-featuree" } do
      expect {
        post :perform, params.merge(hook_params)
        expect(response).to be_success
      }.to change{ ConvertedPullRequest.count }.by(1)
    end

    it "creates a note", vcr: { cassette_name: "hooks-controller_merged-featuree" } do
      expect {
        post :perform, params.merge(hook_params)
      }.to change{ Note.count }.by(1)

      expect(Note.last.title).to eq("Something")
      expect(Note.last.markdown_body).to eq("Not Really")
    end

    it "does not publish the note", vcr: { cassette_name: "hooks-controller_merged-featuree" } do
      post :perform, params.merge(hook_params)
      expect(Note.last.published?).to eq(false)
    end

    context "with auto notify", vcr: { cassette_name: "hooks-controller_merged-auto-notify", match_requests_on: [:uri, :body] } do
      before(:each) { project.update!(auto_notify: true) }

      let!(:r1) { FactoryGirl.create(:reviewer, email: "test@test.com") }
      let!(:r2) { FactoryGirl.create(:reviewer, email: "other@test.com") }

      before(:each) {
        project.reviewers << r1
        project.reviewers << r2
      }

      it "sends emails for the note" do
        expect {
          post :perform, params.merge(hook_params)
        }.to change{ ActionMailer::Base.deliveries.count }.by(2)
      end

      context "without a comment", vcr: { cassette_name: "hooks-controller_merged_without_comment-auto-notify" } do
        let(:params) { JSON.parse(File.read("spec/fixtures/github_hooks/merged_without_comments.json")) }

        it "doesn't create a note" do
          expect {
            post :perform, params.merge(hook_params)
          }.not_to change{ Note.count }
        end

        it "doesn't send emails" do
          expect {
            post :perform, params.merge(hook_params)
          }.not_to change{ ActionMailer::Base.deliveries.count }
        end
      end
    end

    context "with a converted PR" do
      before(:each) { post :perform, params.merge(hook_params) }
      let!(:converted_pr) { ConvertedPullRequest.last }

      it "doesn't create a note", vcr: { cassette_name: "hooks-controller_merged-already-converted" } do
        expect {
          post :perform, params.merge(hook_params)
        }.not_to change{ Note.count }
      end
    end
  end

  describe "closed, not merged" do
    let(:params) { JSON.parse(File.read("spec/fixtures/github_hooks/closed.json")) }

    it "doesn't create a converted pull request", vcr: { cassette_name: "hooks-controller_closed-not-merged" } do
      expect {
        post :perform, params.merge(hook_params)
      }.not_to change{ ConvertedPullRequest.count }
    end

    it "doesn't create a note", vcr: { cassette_name: "hooks-controller_closed-not-merged" } do
      expect {
        post :perform, params.merge(hook_params)
      }.not_to change{ Note.count }
    end
  end

  describe "re-open" do
    let(:params) { JSON.parse(File.read("spec/fixtures/github_hooks/reopened.json")) }

    it "doesn't create a converted pull request", vcr: { cassette_name: "hooks-controller_reopened" } do
      expect {
        post :perform, params.merge(hook_params)
      }.not_to change{ ConvertedPullRequest.count }
    end

    it "doesn't create a note", vcr: { cassette_name: "hooks-controller_reopened" } do
      expect {
        post :perform, params.merge(hook_params)
      }.not_to change{ Note.count }
    end
  end

  describe "opened" do
    let(:params) { JSON.parse(File.read("spec/fixtures/github_hooks/opened.json")) }

    # Spec verified visually
    it "doesn't create a note", vcr: { cassette_name: "hooks-controller_opened" } do
      expect {
        post :perform, params.merge(hook_params).merge(hook: { action: "opened" })
        expect(response).to be_success
      }.not_to change{ Note.count }
    end
  end
end
