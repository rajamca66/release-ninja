class AddProjectIdToRepositories < ActiveRecord::Migration
  def change
    add_column :repositories, :project_id, :integer, null: false
  end
end
