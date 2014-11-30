class ConvertedPullRequest < ActiveRecord::Base
  belongs_to :note
  belongs_to :project
end
