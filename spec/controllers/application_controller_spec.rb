require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  render_views

  context "with a user" do
    let(:user) { FactoryGirl.create(:github_user) }
    before { sign_in(user) }

    it "renders the angular app" do
      get :index
      expect(response).to be_success
      expect(response.body).to include("ng-app")
    end

    it "sets window.current_user to the user json" do
      get :index
      expect(response.body).to include("window.current_user = #{user.to_json}")
    end
  end

  context "without a user" do
    it "renders the angular app" do
      get :index
      expect(response).to be_success
      expect(response.body).to include("ng-app")
    end

    it "sets window.current_user to null" do
      get :index
      expect(response.body).to include("window.current_user = null")
    end
  end

  context "with an invite code" do
    it "sets the invite code" do
      get :index, invite_code: "123"
      expect(session[:invite_code]).to eq("123")
    end

    it "renders the app" do
      get :index, invite_code: "123"
      expect(response).to be_success
      expect(response.body).to include("ng-app")
    end
  end
end
