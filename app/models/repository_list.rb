class RepositoryList
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def repositories
    @repositories ||= begin
      Rails.cache.fetch(expires_in: 2.minute) do
        repos = client.repositories(per_page: 100)
        organizations.each do |org|
          repos = repos + client.repositories(org: org)
        end
        repos
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
