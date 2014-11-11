class Release < ActiveRecord::Base
  has_many :notes
  belongs_to :project
end
