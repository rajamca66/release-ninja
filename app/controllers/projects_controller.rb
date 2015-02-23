class ProjectsController < ApplicationController
  before_filter :authenticate_user!

  def plain
    @project = project
    @grouped_notes = NoteGrouper.new(notes).call

    render layout: "plain"
  end

  private

  def projects
    @projects ||= current_team.projects
  end

  def project
    @project ||= projects.find(params[:id])
  end

  def notes
    project.notes.where(published: true).where.not(published_at: nil)
  end
end
