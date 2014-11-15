class NoteSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :title, :markdown_body, :level, :html_preview, :published, :report_published, :published_at

  def html_preview
    object.html_body
  end

  def report_published
    object.report.try!(:published?) || false
  end
end
