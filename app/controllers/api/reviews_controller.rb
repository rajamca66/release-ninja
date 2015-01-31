class Api::ReviewsController < Api::BaseController
  before_filter :authenticate_user!

  def create
    remove_converted!
    note = NoteSync.new(project, pull_request).call(require_merge: false)

    if note.is_a?(Note)
      project.reviewers.each do |reviewer|
        NotesMailer.reviewer(project, note, user_who_opened, to: reviewer.email).deliver_now
      end

      add_github_comment(project.reviewers.pluck(:email))

      render json: { message: "Awesome, emails have been sent!" }
    elsif note == :no_comment
      render json: { message: "Stop horsing around and give me a valid format comment to work with!" }, status: :unprocessable_entity
    end

  end

  private

  def remove_converted!
    converted = project.converted_pull_requests.find_by(pull_request_id: pull_request.id)
    return unless converted

    converted.note.destroy
    converted.destroy
  end

  def project
    @project ||= current_team.projects.find(params[:project_id])
  end

  def repository
    @repository ||= project.repositories.find(params[:repository_id])
  end

  def client
    @client ||= GithubClient.new(project)
  end

  def pull_request
    @pull_request ||= begin
      pull = client.pull_request(repository.full_name, params[:pull_request_id])
      Git::PullRequest.from_api_response(pull, repository: repository, client: client)
    end
  end

  def user_who_opened
    User.find_by(nickname: pull_request.user_nickname)
  end

  def add_github_comment(emails)
    message = <<-eos.gsub /^\s+/, ""
      Howdy from Release Ninja! I just sent out emails to #{emails.join(", ")}

      :tada:
    eos
    GithubClient.new(project).add_comment(repository.full_name, pull_request.number, message)
  end
end
