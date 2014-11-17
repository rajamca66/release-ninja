class Report < ActiveRecord::Base
  has_and_belongs_to_many :notes
  belongs_to :project
end
