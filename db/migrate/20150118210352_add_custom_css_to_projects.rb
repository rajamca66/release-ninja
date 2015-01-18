class AddCustomCssToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :public_css, :text
  end
end
