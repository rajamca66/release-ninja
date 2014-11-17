class AddUniquenessToNotesReports < ActiveRecord::Migration
  def change
    add_index :notes_reports, [:note_id, :report_id], unique: true
  end
end
