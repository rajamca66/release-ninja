class Note < ActiveRecord::Base
  belongs_to :report
  belongs_to :project

  before_save :set_published_at_if_published

  def set_published_at_if_published
    self.published_at = Time.now if self.published_changed? && self.published?
  end
end
