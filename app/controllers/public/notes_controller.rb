class Public::NotesController < Public::BaseController
  def show
    @project = project
    @grouped_notes = NoteGrouper.new(notes).call
  end

  private

  def project
    @project ||= Project.friendly.find(params[:id])
  end

  def notes
    project.notes.where(published: true).where.not(published_at: nil)
  end
end
