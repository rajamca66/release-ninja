class Api::NotesController < Api::BaseController
  def index
    respond_with :api, project, notes
  end

  def show
    respond_with :api, project, note
  end

  def create

    respond_with :api, project, create_note
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

  def create_note
    notes.create(note_params).tap do |note|
      if note.persisted? && params[:converted_pull_request_id]
        note.create_converted_pull_request(project: project, pull_request_id: params[:converted_pull_request_id])
      end
    end
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
