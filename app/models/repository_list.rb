class RepositoryList
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def repositories
    @repositories ||= begin
      Rails.cache.fetch(expires_in: 2.minute) do
        client.with_pagination do
          repos = client.repositories
          organizations.each do |org|
            repos = repos + client.organization_repositories(org)
          end

          repos
        end
      end
    end
  end

  private

  def client
    @client ||= user.github
  end

  def organizations
    @organizations ||= client.organizations.map(&:login)
  end
end
