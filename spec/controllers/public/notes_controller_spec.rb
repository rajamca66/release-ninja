require 'rails_helper'

RSpec.describe Public::NotesController, :type => :controller do
  render_views

  let!(:project) { FactoryGirl.create(:project) }
  let!(:project2) { FactoryGirl.create(:project) }
  let!(:note1) { FactoryGirl.create(:note, project: project, published: true) }
  let!(:note2) { FactoryGirl.create(:note, project: project, created_at: 5.days.ago, published_at: 4.days.ago, published: true) }
  let!(:note3) { FactoryGirl.create(:note, project: project, created_at: 2.days.ago, published_at: 2.days.ago, published: true) }
  let!(:unpublished) { FactoryGirl.create(:note, project: project) }
  let!(:internal) { FactoryGirl.create(:note, project: project, published: true, internal: true) }

  describe "GET show" do
    it "shows the current project" do
      get :show, id: project.id
      expect(response.body).to include(project.title)
    end

    it "looks up by slug" do
      get :show, id: project.slug
      expect(response.body).to include(project.title)
    end

    it "looks up by domain" do
      request.host = "#{project.slug}.localhost"
      get :show
      expect(response.body).to include(project.title)
    end

    it "looks up by the most top-level domain" do
      request.host = "#{project.slug}.test.herokuapp.com"
      get :show
      expect(response.body).to include(project.title)
    end

    it "contains the correct notes" do
      get :show, id: project.id
      [note1, note2, note3].each do |note|
        expect(response.body).to include(note.html_body)
      end
    end

    it "doesn't contain the unpublished note" do
      get :show, id: project.slug
      expect(response.body).not_to include(unpublished.html_body)
    end

    it "doesn't contain the internal note" do
      get :show, id: project.slug
      expect(response.body).not_to include(internal.html_body)
    end
  end

  describe "GET rss" do
    let(:response) { get :rss, id: project.slug, format: :xml ; super() }

    it 'is successful' do
      expect(response).to be_success
    end

    context "with an invalid project" do
      let(:response) { get :rss, id: "junk", format: :xml ; super() }

      it "raises AR::RecordNotFound" do
        expect {
          response
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    it 'includes title' do
      expect(response.body).to include("<title>#{project.title}</title>")
    end

    it 'includes the notes title' do
      [note1, note2, note3].each do |note|
        expect(response.body).to include("<title>#{CGI::escapeHTML(note.html_title)}</title>")
      end
    end

    it 'renders note markdown as html' do
      note1.update!(title: '*Title*')
      expect(response.body).to_not include("*Title*")
    end

    it 'includes the notes body' do
      [note1, note2, note3].each do |note|
        expect(response.body).to include("<description>#{CGI::escapeHTML(note.html_body)}</description>")
      end
    end

    it "doesn't contain the unpublished note" do
      expect(response.body).not_to include(CGI::escapeHTML(unpublished.html_body))
    end

    it 'includes rss link' do
      expect(response.body).to include("public/#{project.friendly_id}/rss</link>")
    end

    it 'item includes pubDate' do
      note1.update!(published_at: Time.new(2015, 07, 16, 11, 27, 0, -4 * 3600))
      expect(response.body).to include("<pubDate>Thu, 16 Jul 2015 15:27:00 +0000</pubDate>")
    end

    context 'without notes' do
      before(:each) { Note.delete_all }

      it 'does not include items' do
        expect(response.body).to_not include("<item>")
      end
    end
  end
end
