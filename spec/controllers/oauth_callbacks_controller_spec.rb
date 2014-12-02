require 'rails_helper'

RSpec.describe OauthCallbacksController, :type => :controller do
  before(:all) do
    github_auth = YAML.load(File.read( Rails.root.join("spec", "fixtures", "github_auth.yaml")))
    OmniAuth.config.mock_auth[:github] = github_auth
  end

  before(:each) do
    request.env["devise.mapping"] = Devise.mappings[:user]
    request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:github]
  end

  context "without an existing user" do
    it "creates a user" do
      expect {
        get :github
      }.to change{ User.count }.by(1)
    end

    it "creates a team" do
      expect {
        get :github
      }.to change{ Team.count }.by(1)
    end

    context "with an invite code" do
      let(:user) { FactoryGirl.create(:user) }
      let(:team) { user.team }
      let(:invite) { team.invites.create!(user: user, to: "test@test.com") }

      before(:each) { session[:invite_code] = invite.code }

      it "creates a user" do
        expect {
          get :github
        }.to change{ User.count }.by(1)
      end

      it "doesn't create a team" do
        expect {
          get :github
        }.not_to change{ Team.count }
      end

      it "assigns the team" do
        get :github
        expect(User.last.team).to eq(team)
      end

      it "redeems the invite" do
        expect {
          get :github
        }.to change{ invite.reload.redeemed }.from(false).to(true)
      end
    end
  end
end
