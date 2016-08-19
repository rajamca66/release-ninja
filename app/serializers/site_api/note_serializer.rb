class SiteApi::NoteSerializer < ActiveModel::Serializer
  attributes :id, :html_title, :html_body, :published_at, :level, :for_who

  def published_at
    object.published_at.try!(:to_s, :db)
  end
end
