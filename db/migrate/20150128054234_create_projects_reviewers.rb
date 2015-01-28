class CreateProjectsReviewers < ActiveRecord::Migration
  def change
    create_table :projects_reviewers do |t|
      t.references :project, index: true, null: false
      t.references :reviewer, index: true, null: false
      t.timestamps
    end
  end
end
