class NoteSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :title, :markdown_body, :level, :html_preview, :published, :release_published

  def html_preview
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)
    markdown.render(object.markdown_body)
  end

  def release_published
    object.release.try!(:published?) || false
  end
end
