class RepositorySerializer < ActiveModel::Serializer
  attributes :id, :full_name, :url
end
