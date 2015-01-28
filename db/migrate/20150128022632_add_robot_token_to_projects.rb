class AddRobotTokenToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :robot_token, :string
  end
end
