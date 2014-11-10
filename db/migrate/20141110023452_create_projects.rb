class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :title, null: false
      t.references :user, null: false, index: true

      t.timestamps
    end
  end
end
