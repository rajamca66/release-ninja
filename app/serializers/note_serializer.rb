class NoteSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :title, :markdown_body, :level, :html_preview

  def html_preview
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)
    markdown.render(object.markdown_body)
  end
end
