require 'rails_helper'

RSpec.describe Public::NotesController, :type => :controller do
  render_views

  let!(:project) { FactoryGirl.create(:project) }
  let!(:project2) { FactoryGirl.create(:project) }
  let!(:note1) { FactoryGirl.create(:note, project: project, published: true) }
  let!(:note2) { FactoryGirl.create(:note, project: project, created_at: 5.days.ago, published_at: 4.days.ago, published: true) }
  let!(:note3) { FactoryGirl.create(:note, project: project, created_at: 2.days.ago, published_at: 2.days.ago, published: true) }
  let!(:unpublished) { FactoryGirl.create(:note, project: project) }

  it "shows the current project" do
    get :show, id: project.id
    expect(response.body).to include(project.title)
  end

  it "looks up by slug" do
    get :show, id: project.slug
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
end
