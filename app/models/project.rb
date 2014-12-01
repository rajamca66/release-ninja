class Project < ActiveRecord::Base
  belongs_to :user
  belongs_to :team
  has_many :repositories
  has_many :notes
  has_many :reports
  has_many :converted_pull_requests
end
