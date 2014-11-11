class Note < ActiveRecord::Base
  belongs_to :release
  belongs_to :project
end
