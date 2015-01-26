class Reviewer < ActiveRecord::Base
  devise :rememberable, :trackable
end
