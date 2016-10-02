class Site::PublishedNotesController < Site::BaseController
  PER_PAGE = 10

  def index
    update_user_reading_location(paged_notes.first) if user_key
    respond_with :site, paged_notes, each_serializer: SiteApi::NoteSerializer, root: "notes", meta: paged_meta
  end

  def unread
    render json: { unread: unread_count }
  end

  private

  def page
    params.fetch(:page, 1)
  end

  def published_notes
    project.notes.published_filtered.where(internal: false).order(published_at: :desc, id: :desc)
  end

  def paged_notes
    @paged_notes ||= published_notes.page(page).per(per_page)
  end

  def per_page
    params.fetch(:per_page, PER_PAGE)
  end

  def paged_meta
    {
      total_count: paged_notes.total_count,
      total_pages: paged_notes.total_pages,
      page: page
    }
  end

  def user_key
    params[:user_key]
  end

  def update_user_reading_location(note)
    return unless note
    new_location = note.published_at || Time.current

    if user_reading_location.reading_location.blank? || new_location > user_reading_location.reading_location
      user_reading_location.reading_location = new_location
      user_reading_location.save
    end
  end

  def user_reading_location
    @user_reading_location ||= project.user_reading_locations.where(user_key: user_key).first_or_initialize
  end

  def unread_count
    if user_reading_location.reading_location.blank?
      count = published_notes.count
    else
      count = published_notes.where("published_at > ?", user_reading_location.reading_location).count
    end
  end
end
