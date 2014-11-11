class CreateReleases < ActiveRecord::Migration
  def change
    create_table :releases do |t|
      t.string :name, null: false
      t.references :project, null: false, index: true

      t.timestamps
    end
  end
end
