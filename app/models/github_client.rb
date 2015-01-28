class GithubClient < Octokit::Client
  def initialize(project)
    token = project.robot_token || project.users.where.not(github_token: nil).first.github_token
    super(access_token: token)
  end
end
