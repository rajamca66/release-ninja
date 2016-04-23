class Site::PublishedNotesController < Site::BaseController
  PER_PAGE = 10

  def index
    update_user_reading_location(paged_notes.first) if user_key
    respond_with :site, paged_notes, each_serializer: SiteApi::NoteSerializer, root: "notes"
  end

  private

  def page
    params.fetch(:page, 1)
  end

  def published_notes
    project.notes.published_filtered.order(published_at: :desc, id: :desc)
  end

  def paged_notes
    @paged_notes ||= published_notes.page(page).per(PER_PAGE).to_a
  end

  def user_key
    params[:user_key]
  end

  def update_user_reading_location(note)
    new_location = note.published_at || Time.current

    if user_reading_location.reading_location.blank? || new_location > user_reading_location.reading_location
      user_reading_location.reading_location = new_location
      user_reading_location.save
    end
  end

  def user_reading_location
    @user_reading_location ||= project.user_reading_locations.where(user_key: user_key).first_or_initialize
  end
end
