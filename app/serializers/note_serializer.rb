class NoteSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :title, :markdown_body, :level, :html_title, :html_body,
             :published, :published_at, :internal, :filter_str, :for_who

  def filter_str # AMS doesn't like you using filter
    object.filter unless object.published?
  end

  def published_at
    object.published_at.try!(:to_s, :db)
  end
end
