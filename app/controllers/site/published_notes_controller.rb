class Site::PublishedNotesController < Site::BaseController
  def index
    respond_with :site, published_notes, each_serializer: SiteApi::NoteSerializer
  end

  private

  def published_notes
    project.notes.published_filtered.order(published_at: :desc, id: :desc)
  end
end
