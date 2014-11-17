class Api::ReportsController < Api::BaseController
  def index
    respond_with :api, project, reports
  end

  def show
    respond_with :api, project, report
  end

  def create
    respond_with :api, project, reports.create(report_params)
  end

  def update
    report.update!(report_params)
    respond_with :api, project, report
  end

  def destroy
    respond_with :api, project, report.destroy
  end

  def add_note
    report.notes << note
    respond_with :api, project, report
  rescue ActiveRecord::RecordNotUnique
    respond_with :api, project, report
  end

  def remove_note
    report.notes.delete(note)
    respond_with :api, project, report
  end

  def html
    html = ReportHtmlRenderer.new(project).render
    html = CGI::escapeHTML(html)
    render text: html
  end

  private

  def project
    @project ||= current_user.projects.find(params[:project_id])
  end

  def note
    project.notes.find(params[:note_id])
  end

  def reports
    @notes ||= project.reports
  end

  def report
    @note ||= reports.find(params[:id])
  end

  def report_params
    params.permit(:name)
  end
end

class ReportHtmlRenderer
  def initialize(project)
    @notes = NoteGrouper.new(project.notes).call
  end

  def render
    raw_html = ApplicationController.new.render_to_string(
      template: 'api/reports/html',
      locals: { :@notes => @notes },
      layout: false
    )
  end
end
