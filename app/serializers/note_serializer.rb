class NoteSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :title, :markdown_body, :level, :html_preview, :published, :published_at

  def html_preview
    object.html_body
  end
end
