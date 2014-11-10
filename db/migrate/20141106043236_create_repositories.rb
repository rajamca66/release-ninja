class CreateRepositories < ActiveRecord::Migration
  def change
    create_table :repositories do |t|
      t.string :full_name, null: false
      t.boolean :private, null: false
      t.text :url, null: false
      t.string :default_branch, null: false
      t.integer :github_id, null: false

      t.timestamps
    end
  end
end
