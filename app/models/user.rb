class User < ActiveRecord::Base
  devise :rememberable, :trackable

  belongs_to :team
  has_many :projects
  has_many :invites

  def github
    @github ||= GithubClient.new(nil, access_token: github_token) if github_token
  end

  def mailing_email
    super || email
  end
end
