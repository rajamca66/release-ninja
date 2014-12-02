class Team < ActiveRecord::Base
  has_many :users
  has_many :projects
  has_many :repositories, through: :projects
  has_many :invites
end
