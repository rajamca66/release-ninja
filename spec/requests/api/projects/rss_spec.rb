require 'rails_helper'

RSpec.describe 'Api::Products Rss' do

  let(:project) do
    FactoryGirl.create(:project,
      team: FactoryGirl.create(:team)
    )
  end

  context 'when project is valid' do
    it 'returns 200' do
      expect(get(api_project_rss_path(project.id))).to eq 200
    end
  end
end
