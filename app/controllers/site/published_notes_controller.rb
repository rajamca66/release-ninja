class Site::PublishedNotesController < Site::BaseController
  PER_PAGE = 10

  def index
    respond_with :site, published_notes.page(page).per(PER_PAGE), each_serializer: SiteApi::NoteSerializer
  end

  private

  def page
    params.fetch(:page, 1)
  end

  def published_notes
    project.notes.published_filtered.order(published_at: :desc, id: :desc)
  end
end
