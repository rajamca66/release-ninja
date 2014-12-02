require 'rails_helper'

RSpec.describe ApplicationController, :type => :controller do
  context "without a user" do
    it "is success" do
      get :index
      expect(response).to be_success
    end

    context "with an invite code" do
      it "sets the invite code" do
        expect {
          get :index, invite_code: "test"
        }.to change{ session[:invite_code] }.to eq("test")
      end
    end
  end
end
