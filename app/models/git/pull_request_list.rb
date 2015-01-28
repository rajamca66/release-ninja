Git::PullRequestList = Struct.new(:user, :repository, :size, :page, :show_comments) do
  def to_a
    filtered_requests
  end

  private

  def pull_requests
    @pull_requests ||= user.github.pull_requests(repository.full_name, state: 'closed', per_page: size, page: page)
  end

  def filtered_requests
    @filtered_requests ||= pull_requests.map do |pr|
      Git::PullRequest.from_api_response(pr, repository: repository, client: user.github)
    end
  end
end
