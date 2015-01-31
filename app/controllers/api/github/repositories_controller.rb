class Api::Github::RepositoriesController < Api::BaseController
  def index
    render json: repository_list.repositories.map(&:to_h)
  end

  private

  def repository_list
    @repository_list ||= RepositoryList.new(current_user)
  end
end
