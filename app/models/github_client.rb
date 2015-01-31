class GithubClient < Octokit::Client
  def initialize(project, access_token: nil)
    return super(access_token: access_token) if access_token

    token = project.robot_token || project.users.where.not(github_token: nil).first.github_token
    super(access_token: token)
  end

  def with_pagination
    self.auto_paginate = true
    yield
  ensure
    self.auto_paginate = false
  end
end
