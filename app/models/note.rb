class Note < ActiveRecord::Base
  has_and_belongs_to_many :reports
  has_one :converted_pull_request
  belongs_to :project, touch: true

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

  def self.github_filtered
    where(filter: "github").where(published: [nil, false])
  end

  def self.product_filtered
    where(filter: "product").where(published: [nil, false])
  end

  def self.published_filtered
    where(published: true).where("published_at IS NOT NULL")
  end

  private

  def html_renderer
    Redcarpet::Render::HTML.new(hard_wrap: true, link_attributes: { target: "_blank" })
  end

  def markdowner
    @@markdowner ||= Redcarpet::Markdown.new(html_renderer, autolink: true, tables: true)
  end
end
