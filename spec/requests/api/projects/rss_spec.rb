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
    context 'without notes' do
      it 'does not include items' do
        expect(project_rss).to_not include "<item>"
      end
    end
    context 'with unpublished notes' do
      before do
        project.notes.create(
          title: 'Fix all the things',
          markdown_body: 'Fix, fixed, fixedy, fix.',
          level: :minor
        )
      end
      it 'does not include items' do
        expect(project_rss).to_not include "<item>"
      end
    end
    context 'with published notes' do
      before do
        project.notes.create(
          title: 'Fix all the things',
          markdown_body: 'Fix, fixed, fixedy, fix.',
          level: :minor,
          published_at: Time.new(2015, 07, 16, 11, 27, 0, -4 * 3600),
          published: true
        )
      end
      it 'includes items' do
        expect(project_rss).to include "<item>"
      end
      it 'item includes title' do
        expect(project_rss).to include "<item><title>Fix all the things>/title>"
      end
      it 'item includes pubDate' do
        expect(project_rss).to include "<pubDate>Thu, 16 Jul 2015 11:27:00 -0400<pubDate>"
      end
    end
  end
end
