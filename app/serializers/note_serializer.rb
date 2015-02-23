class NoteSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :title, :markdown_body, :level, :html_title, :html_body, :published, :published_at, :internal

  def published_at
    object.published_at.try!(:to_s, :db)
  end
end
