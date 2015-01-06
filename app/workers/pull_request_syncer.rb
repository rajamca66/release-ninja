class PullRequestSyncer
  attr_reader :project

  def perform(project_id)
    @project = Project.find(project_id)
    updates = {}
    send_email = false

    project.repositories.each do |repository|
      # Try with each user on the project in case the github credentials are invalid
      @project.users.each do |user|
        pull_requests = list_prs(repository, user)
        updates[repository] = pull_requests.map(&method(:process_pull_request)).reject(&:blank?)
        send_email = true if updates[repository].any?

        break
      end
    end

    NotesMailer.notify(project, updates).deliver if send_email
  end

  private

  def process_pull_request(pr)
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

  def list_prs(repository, user)
    pull_requests = Git::PullRequestList.new(user, repository, 20, 1).to_a
    pull_requests.each do |pr|
      pr.has_note = true if project.converted_pull_requests.find_by(pull_request_id: pr.id)
    end
  end
end