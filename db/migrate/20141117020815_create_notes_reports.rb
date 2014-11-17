class CreateNotesReports < ActiveRecord::Migration
  def change
    create_table :notes_reports do |t|
      t.references :note, index: true, null: false
      t.references :report, index: true, null: false
      t.integer :order, default: nil
      t.timestamps
    end
  end
end
