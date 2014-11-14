class NoteSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :title, :markdown_body, :level, :html_preview, :published, :report_published, :published_at

  def html_preview
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)
    markdown.render(object.markdown_body)
  end

  def report_published
    object.report.try!(:published?) || false
  end
end
