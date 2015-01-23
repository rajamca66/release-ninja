module Api
  class HooksController < BaseController
    def index
      list = project.repositories.map do |repo|
        hook_api(repo).ninja_hook || { repo: repo.full_name, created_at: nil, repo_id: repo.id }
      end

      render json: list
    end

    def create
      render json: hook_api(repository).ensure_hook(hook_url(Rails.application.default_url_options))
    end

    private

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
