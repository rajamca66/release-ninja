class HooksController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :verify_payload unless Rails.env.test? # Too much PITA right now

  def perform
    return render json: "no pr given" unless pull_request

    if pull_request.state == "closed"
      closed
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
      Git::PullRequest.from_api_response(params[:pull_request], repository: repository, client: user.github_client)
    end
  end

  def closed
    pr = pull_request
    pr.has_note = true if project.converted_pull_requests.find_by(pull_request_id: pr.id)

    unless pr.has_note
      comment_to_convert = pr.comments.first
      return unless comment_to_convert && pr.merged_at

      params = comment_to_convert.as_params.merge(created_at: pr.merged_at)
      project.notes.create(params).tap do |note|
        if note.persisted?
          note.create_converted_pull_request(project: project, pull_request_id: pr.id)
        else
          Rails.logger.error("Note not persisted: #{note.errors.full_messages}")
        end
      end
    end
  end

  def verify_payload
    payload_body = request.body.read
    signature = 'sha1=' + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), project.secret_token, payload_body)
    render text: "Signatures didn't match!", status: :unprocessable_entity unless Rack::Utils.secure_compare(signature, request.env['HTTP_X_HUB_SIGNATURE'])
  end
end
