class Reviewer < ActiveRecord::Base
  devise :rememberable, :trackable

  has_and_belongs_to_many :projects
end
