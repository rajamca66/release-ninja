class NoteSync
  attr_reader :project, :pull_request

  def initialize(project, pull_request)
    @project = project
    @pull_request = pull_request
  end

  def call(require_merge: true)
    converted = project.converted_pull_requests.find_by(pull_request_id: pull_request.id)
    return converted.note if converted

    comment_to_convert = pull_request.comments.first

    return :no_comment unless comment_to_convert
    return :not_merged if require_merge && !pull_request.merged_at

    params = comment_to_convert.as_params.merge(created_at: pull_request.merged_at)
    project.notes.create(params).tap do |note|
      raise "Note not persisted" unless note.persisted?
      note.create_converted_pull_request(project: project, pull_request_id: pull_request.id)
      @did_create = true
    end
  end

  def did_create_note?
    @did_create
  end
end
