class AddTeamIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :team_id, :integer, null: false
    add_index :users, :team_id
  end
end
