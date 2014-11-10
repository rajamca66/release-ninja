class CreateRepositories < ActiveRecord::Migration
  def change
    create_table :repositories do |t|
      t.string :name
      t.string :full_name
      t.text :description
      t.boolean :private
      t.text :url
      t.string :default_branch
      t.integer :github_id

      t.timestamps
    end
  end
end
