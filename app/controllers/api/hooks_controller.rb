## todo: Randomize the secret for each hook

module Api
  class HooksController < BaseController
    def index
      list = project.repositories.map do |repo|
        hook_api(repo).ninja_hook || { repo: repo.full_name, created_at: nil, repo_id: repo.id }
      end

      render json: list
    end

    def create
      render json: hook_api(repository).ensure_hook(hook_url(Rails.application.default_url_options.merge(url_params)))
    end

    def destroy
      hook_api(repository).delete_hook(params[:id])
      render json: { repo: repository.full_name, created_at: nil, repo_id: repository.id }
    end

    private

    def url_params
      { project_id: project.id, repository_id: repository.id }
    end

    def hook_api(repo)
      Git::Webhooks.new(current_user, repo)
    end

    def project
      @project ||= current_team.projects.find(params[:project_id])
    end

    def repository
      @repository ||= current_team.repositories.find(params[:repository_id])
    end
  end
end
