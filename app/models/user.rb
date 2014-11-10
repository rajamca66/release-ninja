class User < ActiveRecord::Base
  devise :rememberable, :trackable, :omniauthable, omniauth_providers: [:github]

  def github_client
    @github_client ||= Github.new(oauth_token: github_token) if github_token
  end
end
