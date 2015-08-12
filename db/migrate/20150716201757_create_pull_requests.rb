class CreatePullRequests < ActiveRecord::Migration
  def change
    create_table :pull_requests do |t|
      t.integer :github_id, null: false
      t.string :github_state, null: false
      t.string :title, null: false
      t.string :html_url, null: false
      t.string :body, null: false
      t.string :github_user_name, null: false

      t.datetime :github_created_at, null: false
      t.datetime :github_updated_at, null: false
      t.timestamps
    end
  end
end
