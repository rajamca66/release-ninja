class Note < ActiveRecord::Base
  FIX = "fix"
  MAJOR = "major"
  MINOR = "minor"

  has_and_belongs_to_many :reports
  belongs_to :project

  before_save :set_published_at_if_published

  def set_published_at_if_published
    self.published_at = Time.now if self.published_changed? && self.published?
  end

  def html_body
    markdowner.render(markdown_body)
  end

  def html_title
    markdowner.render(title)
  end

  private

  def html_renderer
    Redcarpet::Render::HTML.new(hard_wrap: true, link_attributes: { target: "_blank" })
  end

  def markdowner
    @@markdowner ||= Redcarpet::Markdown.new(html_renderer, autolink: true, tables: true)
  end
end
