class RepositoryList
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def repositories
    @repositories ||= begin
      Rails.cache.fetch(expires_in: 2.minute) do
        repos = client.repositories.list(per_page: 100).to_a
        organizations.each do |org|
          repos = repos + client.repositories.list(org: org).to_a
        end
        repos
      end
    end
  end

  private

  def client
    @client ||= user.github_client
  end

  def organizations
    @organizations ||= client.organizations.list.map(&:login)
  end
end
