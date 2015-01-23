class Api::ProjectsController < Api::BaseController
  def index
    respond_with :api, projects.order(updated_at: :desc)
  end

  def show
    respond_with :api, project
  end

  def create
    project = Project.transaction do
      projects.create(project_params.merge(user_id: current_user.id)).tap do |project|
        create_and_link_repositories!(project)
      end
    end
    respond_with :api, project
  end

  def update
    project.update_attributes(project_params)
    respond_with :api, project
  end

  def destroy
    respond_with :api, project.destroy
  end

  private

  def repositories
    @repositories ||= RepositoryList.new(current_user).repositories
  end

  def create_and_link_repositories!(project)
    params.fetch(:repos, []).each do |full_name|
      info = repositories.find{ |p| p["full_name"] == full_name }

      Repository.create_from_github!(project, info).tap do |repo|
        url_for_hook = hook_url(Rails.application.default_url_options.merge(project_id: project.id, repository_id: repo.id))
        Git::Webhooks.new(current_user, repo).ensure_hook(url_for_hook, secret: project.secret_token)
      end
    end
  end

  def projects
    @projects ||= current_team.projects
  end

  def project
    @project ||= projects.find(params[:id])
  end

  def project_params
    params.permit(:title, :public_header_background, :public_logo_url, :public_css)
  end
end
