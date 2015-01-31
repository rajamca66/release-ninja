require 'rails_helper'

RSpec.describe Api::RepositoriesController, :type => :controller do
  let(:user) { FactoryGirl.create(:github_user) }
  let!(:project) { FactoryGirl.create(:project, user: user, team: user.team) }

  before(:each) {
    sign_in(user)
    request.env["HTTP_ACCEPT"] = 'application/json'
  }

  describe "GET show" do
    let!(:r1) { FactoryGirl.create(:customer_know, project: project) }

    it "has the right repository" do
      get :show, id: r1.id
      expect(response_json["id"]).to eq(r1.id)
    end
  end
end
