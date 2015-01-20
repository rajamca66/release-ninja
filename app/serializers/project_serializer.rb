class ProjectSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  class RepositorySerializer < ActiveModel::Serializer
    attributes :id, :full_name, :url
  end

  attributes :id, :created_at, :title, :public_header_background, :public_logo_url, :public_css, :slug, :url

  has_many :repositories, each_serializer: RepositorySerializer

  def url
    root_url(subdomain: object.slug)
  end
end
