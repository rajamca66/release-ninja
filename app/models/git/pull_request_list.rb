Git::PullRequestList = Struct.new(:user, :repository, :size, :page, :show_comments) do
  def to_a
    filtered_requests
  end

  private

  def pull_requests
    @pull_requests ||= client.pulls.list(repository.owner, repository.repo, state: 'closed', per_page: size, page: page)
  end

  def filtered_requests
    @filtered_requests ||= pull_requests.map do |pr|
      Git::PullRequest.from_api_response(pr, repository: repository, client: client)
    end
  end

  def client
    @client ||= user.github_client(page: false)
  end
end
