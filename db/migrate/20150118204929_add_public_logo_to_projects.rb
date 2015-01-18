class AddPublicLogoToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :public_logo_url, :text
  end
end
