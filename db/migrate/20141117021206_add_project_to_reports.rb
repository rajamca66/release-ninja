class AddProjectToReports < ActiveRecord::Migration
  def change
    add_column :reports, :project_id, :integer, null: false
    add_index :reports, :project_id
  end
end
