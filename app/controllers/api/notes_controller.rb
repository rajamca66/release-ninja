class Api::NotesController < Api::BaseController
  def index
    respond_with :api, project, filtered_notes.order(id: :desc)
  end

  def show
    respond_with :api, project, note(base: filtered_notes)
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

  def team_emails
    project.reviewers.each do |reviewer|
      NotesMailer.reviewer(project, note, current_user, to: reviewer.email).deliver_now
    end

    render json: project.reviewers.pluck(:email)
  end

  private

  def project
    @project ||= current_team.projects.find(params[:project_id])
  end

  def create_note
    notes.create(note_params).tap do |note|
      if note.persisted? && params[:converted_pull_request_id]
        note.create_converted_pull_request(project: project, pull_request_id: params[:converted_pull_request_id])
      end
    end
  end

  VALID_FILTERS = ["github", "product", "published"]
  def filtered_notes
    return notes unless params[:filter]
    return notes unless VALID_FILTERS.include?(params[:filter])
    notes.send(params[:filter] + "_filtered")
  end

  def notes
    @notes ||= project.notes
  end

  def note(base: notes)
    @note ||= base.find(params[:id])
  end

  def note_params
    params.permit(:title, :level, :markdown_body, :order, :published, :published_at, :internal, :filter).tap do |p|
      raise if p[:filter] && !VALID_FILTERS.include?(p[:filter])
    end
  end
end
