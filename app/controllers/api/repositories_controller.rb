class Api::RepositoriesController < Api::BaseController
  def show
    respond_with :api, repository
  end

  private

  def repositories
    @repositories ||= current_team.repositories
  end

  def repository
    @repository ||= repositories.find(params[:id])
  end
end
