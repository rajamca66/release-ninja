class Api::NotesController < Api::BaseController
  def index
    respond_with :api, project, notes
  end

  def show
    respond_with :api, project, note
  end

  def create
    respond_with :api, project, notes.create(note_params)
  end

  def update
    note.update!(note_params)
    respond_with :api, project, note
  end

  def destroy
    respond_with :api, project, note.destroy
  end

  private

  def project
    @project ||= current_user.projects.find(params[:project_id])
  end

  def notes
    @notes ||= project.notes
  end

  def note
    @note ||= notes.find(params[:id])
  end

  def note_params
    params.permit(:title, :level, :markdown_body, :order, :published, :published_at)
  end
end
