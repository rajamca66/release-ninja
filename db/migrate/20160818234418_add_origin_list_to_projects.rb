class AddOriginListToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :origin_list, :string, null: false, default: [], array: true
  end
end
