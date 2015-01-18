class AddPublicCssToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :public_header_background, :string
  end
end
