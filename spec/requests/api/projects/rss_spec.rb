require 'rails_helper'

RSpec.describe 'Api::Products Rss' do

  let(:project) do
    FactoryGirl.create(:project,
      title: 'ReleaseNinja',
      team: FactoryGirl.create(:team)
    )
  end

  let(:project_rss_request) { get(api_project_rss_path(project.id)) }
  let(:project_rss) { project_rss_request; response.body }

  context 'when project is valid' do
    it 'returns 200' do
      expect(project_rss_request).to eq 200
    end
    it 'includes title' do
      expect(project_rss).to include '<title>ReleaseNinja</title>'
    end
    it 'includes description' do
      expect(project_rss).to include '<description>ReleaseNinja</description>'
    end
    it 'includes link' do
      expect(project_rss).to include "public/#{project.id}</link>"
    end
  end
end
