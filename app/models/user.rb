class User < ActiveRecord::Base
  devise :rememberable, :trackable

  belongs_to :team
  has_many :projects
  has_many :invites

  def github_client(page: true)
    @github_client ||= Github.new(oauth_token: github_token, auto_pagination: page) if github_token
  end

  def github
    @github ||= Octokit::Client.new(access_token: github_token) if github_token
  end
end
