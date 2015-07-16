require 'rails_helper'

RSpec.describe 'Api::Products Rss' do

  context 'when project is valid' do
    it 'returns 200' do
      expect(get(api_projects_rss_path(project.id))).to eq 200
    end
  end
end
