class Project < ActiveRecord::Base
  belongs_to :user
  has_many :repositories
  has_many :notes
  has_many :releases
end
