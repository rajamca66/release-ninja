class Project < ActiveRecord::Base
  belongs_to :user
  belongs_to :team
  has_many :repositories
  has_many :notes
  has_many :reports
  has_many :converted_pull_requests
  has_and_belongs_to_many :reviewers

  before_create :create_secret_token

  delegate :users, to: :team

  extend FriendlyId
  friendly_id :title, use: :slugged
  validates_format_of :slug, with: /\A[a-z0-9\-]+\z/i

  def should_generate_new_friendly_id?
    title_changed?
  end

  def create_secret_token
    self.secret_token = SecureRandom.hex(20)
  end
end
