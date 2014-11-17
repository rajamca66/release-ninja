class ReportSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :project_id, :name

  has_many :notes
end
