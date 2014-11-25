class AddOwnerToRepositories < ActiveRecord::Migration
  def change
    add_column :repositories, :owner, :string, null: false
    add_column :repositories, :repo, :string, null: false
  end
end
