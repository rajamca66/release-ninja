class Api::Github::RepositoriesController < Api::BaseController
  def index
    render json: repository_list.repositories
  end

  private

  def repository_list
    @repository_list ||= RepositoryList.new(current_user)
  end
end
