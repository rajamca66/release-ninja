class Api::Github::PullRequestsController < Api::BaseController
  def index
    render json: list
  end

  private

  def repository
    @repository ||= current_user.repositories.find(params[:repository_id])
  end

  def page
    params.fetch(:page, 1)
  end

  def size
    params.fetch(:size, 10)
  end

  def project
    current_team.projects.find(params[:project_id])
  end

  def list
    @list ||= begin
      pull_requests = Git::PullRequestList.new(current_user, repository, size, page).to_a
      pull_requests.each do |pr|
        pr.has_note = true if project.converted_pull_requests.find_by(pull_request_id: pr.id)
      end
    end
  end
end
