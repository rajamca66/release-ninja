class User < ActiveRecord::Base
  devise :rememberable, :trackable, :omniauthable, omniauth_providers: [:github]

  belongs_to :team
  has_many :projects
  has_many :repositories, through: :projects

  def github_client(page: true)
    @github_client ||= Github.new(oauth_token: github_token, auto_pagination: page) if github_token
  end
end
