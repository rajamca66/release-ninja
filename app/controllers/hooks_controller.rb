class HooksController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :verify_payload unless Rails.env.test? # Too much PITA right now

  def perform
    return render json: "no pr given" unless pull_request

    if pull_request.state == "closed"
      closed
    elsif params[:hook][:action] == "opened" && pull_request.state == "open"
      opened
    end

    render json: true
  end

  private

  def project
    @project ||= Project.find(params[:project_id])
  end

  def repository
    @repository ||= Repository.find(params[:repository_id])
  end

  def user
    project.users.first
  end

  def pull_request
    @pull_request ||= if params[:pull_request]
      Git::PullRequest.from_api_response(params[:pull_request], repository: repository, client: GithubClient.new(project))
    end
  end

  def user_who_opened
    User.find_by(nickname: pull_request.user_nickname)
  end

  def closed
    note_sync = NoteSync.new(project, pull_request)
    note = note_sync.call

    if note_sync.did_create_note? && project.auto_notify?
      project.reviewers.each do |reviewer|
        NotesMailer.reviewer(project, note, user_who_opened, to: reviewer.email).deliver_now
      end

      CommentManager.new(project, repository, pull_request).add_emailed_comment(project.reviewers.pluck(:email))
    elsif note == :no_comment && pull_request.merged_at
      CommentManager.new(project, repository, pull_request).merged_without_note
    end
  end

  def opened
    CommentManager.new(project, repository, pull_request).add_opened_comment
  end

  def verify_payload
    payload_body = request.body.read
    signature = 'sha1=' + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), project.secret_token, payload_body)
    render text: "Signatures didn't match!", status: :unprocessable_entity unless Rack::Utils.secure_compare(signature, request.env['HTTP_X_HUB_SIGNATURE'])
  end

  CommentManager = Struct.new(:project, :repository, :pull_request) do
    include Rails.application.routes.url_helpers


    def add_opened_comment
      add_comment(opened_comment)
    end

    def add_emailed_comment(emails)
      add_comment(emailed_comment(emails))
    end

    def merged_without_note
      add_comment(merged_without_note_comment)
    end

    private

    def add_comment(message)
      GithubClient.new(project).add_comment(repository.full_name, pull_request.number, message)
    end

    def opened_comment
      <<-eos.gsub(/^\s+/, "").gsub(/<BR>/, "\n")
      Howdy from Release Ninja! You should write a release note targeted at a semi-technical end user who is
      not familiar with the code base. Include at least 1 image, wherever possible. [Review the help article](#{help_url}) if
      you are not familiar with Release Ninja.

      <BR>When your pull request is ready, do one of the following:<BR>

      * [Notify Release Team](#{workflow_review_url(pull_request_id: pull_request.number, project_id: project.id, repository_id: repository.id)})
      * Don't notify anyone because it's a small change or doesn't concern them

      Whatever you do though, make sure you :tada:
      eos
    end

    def emailed_comment(emails)
      <<-eos.gsub /^\s+/, ""
      Howdy from Release Ninja! I just created a note and sent out emails to #{emails.join(", ")}

      :tada:
      eos
    end

    def merged_without_note_comment
      <<-eos.gsub /^\s+/, ""
      Howdy from Release Ninja! It appears that you merged without a release note comment? It's never too late!

      :tada:
      eos
    end
  end
end
