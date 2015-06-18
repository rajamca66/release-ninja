class AddAutoNotifyToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :auto_notify, :boolean
  end
end
