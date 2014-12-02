require 'rails_helper'

RSpec.describe Api::InvitesController, :type => :controller do
  let(:user) { FactoryGirl.create(:user) }
  let(:team) { user.team }

  before(:each) {
    sign_in(user)
    request.env["HTTP_ACCEPT"] = 'application/json'
  }

  describe "POST create" do
    it "creates an invite" do
      expect {
        post :create, to: "test@test.com"
      }.to change{ team.invites.count }.by(1)
      expect(response).to be_success
    end

    it "has different codes" do
      post :create, to: "test@test.com"
      post :create, to: "test2@test.com"

      expect(Invite.first.code).not_to eq(Invite.last.code)
    end

    it "sends a mail" do
      expect {
        post :create, to: "test@test.com"
      }.to change{ ActionMailer::Base.deliveries.count }.by(1)
    end

    context "with a pending invite" do
      let!(:invite) { team.invites.create!(user: user, to: "test@test.com") }

      it "doesn't create an invite" do
        expect {
          post :create, to: "test@test.com"
        }.not_to change{ team.invites.count }
        expect(response).not_to be_success
      end
    end
  end
end
