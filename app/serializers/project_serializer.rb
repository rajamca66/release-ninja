class ProjectSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  class RepositorySerializer < ActiveModel::Serializer
    attributes :id, :full_name, :url
  end

  attributes :id, :created_at, :title, :public_header_background, :public_logo_url, :public_css, :slug, :url, :robot_token,
             :report_url

  has_many :repositories, each_serializer: RepositorySerializer

  def url
    if production? && !heroku?
      root_url(subdomain: object.slug)
    else
      public_url(object.id)
    end
  end

  def report_url
    Rails.application.routes.url_helpers.report_url(object.id)
  end

  private

  def production?
    Rails.env.production?
  end

  def heroku?
    ENV.fetch("HOST_URL", "").include?("herokuapp.com")
  end
end
