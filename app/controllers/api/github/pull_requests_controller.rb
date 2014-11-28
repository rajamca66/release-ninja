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

  def list
    @list ||= Git::PullRequestList.new(current_user, repository, size, page).to_a
  end
end
