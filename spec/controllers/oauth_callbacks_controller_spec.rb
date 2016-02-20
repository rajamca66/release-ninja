require 'rails_helper'

RSpec.describe OauthCallbacksController, :type => :controller do
  def github_auth
    @github_auth ||= YAML.load(File.read( Rails.root.join("spec", "fixtures", "github_auth.yaml")))
  end

  def google_auth
    @google_auth ||= YAML.load(File.read( Rails.root.join("spec", "fixtures", "google_auth.yaml")))
  end

  before(:all) do
    OmniAuth.config.mock_auth[:github] = github_auth
    OmniAuth.config.mock_auth[:google_oauth2] = google_auth
  end

  context "for google" do
    before(:each) do
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:google_oauth2]
    end

    context "without a reviewer" do
      it "creates a reviewer" do
        expect {
          get :create, provider: :google_oauth2
        }.to change{ Reviewer.count }.by(1)

        expect(Reviewer.last.email).to eq(google_auth.info.email)
        expect(Reviewer.last.name).to eq(google_auth.info.name)
      end

      it "signs in the reviewer" do
        expect {
          get :create, provider: :google_oauth2
        }.to change{ controller.current_reviewer }.from(nil)
      end
    end

    context "with a reviewer" do
      let!(:reviewer) { FactoryGirl.create(:reviewer, email: google_auth.info.email, name: "junk") }

      it "doesn't create a reviewer" do
        expect {
          get :create, provider: :google_oauth2
        }.not_to change{ Reviewer.count }
      end

      it "updates the name" do
        expect {
          get :create, provider: :google_oauth2
        }.to change{ reviewer.reload.name }.from("junk").to(google_auth.info.name)
      end
    end
  end

  context "for github" do
    before(:each) do
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:github]
    end

    context "without an existing user" do
      it "creates a user" do
        expect {
          get :create, provider: :github
        }.to change{ User.count }.by(1)
      end

      it "creates a team" do
        expect {
          get :create, provider: :github
        }.to change{ Team.count }.by(1)
      end

      it "signs in the user" do
        expect {
          get :create, provider: :github
        }.to change{ controller.current_user }.from(nil)
      end

      context "with an invited email" do
        let(:user) { FactoryGirl.create(:user) }
        let(:team) { user.team }
        let!(:invite) { team.invites.create!(user: user, to: "GITHUB@test.com") }

        it "creates a user" do
          expect {
            get :create, provider: :github
          }.to change{ User.count }.by(1)
        end

        it "doesn't create a team" do
          expect {
            get :create, provider: :github
          }.not_to change{ Team.count }
        end

        it "assigns the team" do
          get :create, provider: :github
          expect(User.last.team).to eq(team)
        end

        it "redeems the invite" do
          expect {
            get :create, provider: :github
          }.to change{ invite.reload.redeemed }.from(false).to(true)
        end
      end

      context "with an invite code" do
        let(:user) { FactoryGirl.create(:user) }
        let(:team) { user.team }
        let(:invite) { team.invites.create!(user: user, to: "test@test.com") }

        before(:each) { session[:invite_code] = invite.code }

        it "creates a user" do
          expect {
            get :create, provider: :github
          }.to change{ User.count }.by(1)
        end

        it "doesn't create a team" do
          expect {
            get :create, provider: :github
          }.not_to change{ Team.count }
        end

        it "assigns the team" do
          get :create, provider: :github
          expect(User.last.team).to eq(team)
        end

        it "redeems the invite" do
          expect {
            get :create, provider: :github
          }.to change{ invite.reload.redeemed }.from(false).to(true)
        end

        it "unsets the session" do
          expect {
            get :create, provider: :github
          }.to change{ session[:invite_code] }.to(nil)
        end

        context "that is bad" do
          before(:each) { session[:invite_code] = "bad" }

          it "creates a user" do
            expect {
              get :create, provider: :github
            }.to change{ User.count }.by(1)
          end

          it "creates a team" do
            expect {
              get :create, provider: :github
            }.to change{ Team.count }.by(1)
          end

          it "unsets the session" do
            expect {
              get :create, provider: :github
            }.to change{ session[:invite_code] }.to(nil)
          end
        end

        context "with a duplicate invite" do
          let!(:invite2) { team.invites.create!(user: user, to: "github@test.com") }

          it "redeems both invites" do
            expect {
              get :create, provider: :github
            }.to change{ Invite.where(redeemed: true).count }.from(0).to(2)
          end
        end
      end
    end

    context "with a user" do
      let!(:user) { FactoryGirl.create(:user, email: github_auth.info.email) }

      it "doesn't create a user" do
        expect {
          get :create, provider: :github
        }.not_to change{ User.count }
      end

      it "signs in the user" do
        expect {
          get :create, provider: :github
        }.to change{ controller.current_user }.from(nil).to(user)
      end
    end
  end
end
