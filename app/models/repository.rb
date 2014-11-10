class Repository < ActiveRecord::Base
  belongs_to :project
  has_one :user, through: :project

  def self.create_from_github!(project, info = {})
    project.repositories.create!(
      full_name: info["full_name"],
      private: info["private"],
      url: info["html_url"],
      default_branch: info["default_branch"],
      github_id: info["id"]
    )
  end
end
