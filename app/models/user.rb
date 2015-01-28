class User < ActiveRecord::Base
  devise :rememberable, :trackable

  belongs_to :team
  has_many :projects
  has_many :invites

  def github
    @github ||= Octokit::Client.new(access_token: github_token) if github_token
  end
end
