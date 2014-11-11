class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.string :title, null: false
      t.string :level, null: false
      t.text :markdown_body, null: false
      t.integer :order, null: false, default: 0

      t.references :release, index: true
      t.references :project, null: false, index: true

      t.timestamps
    end
  end
end
