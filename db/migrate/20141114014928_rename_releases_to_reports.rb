class RenameReleasesToReports < ActiveRecord::Migration
  def change
    rename_table :releases, :reports
    remove_index :notes, :release_id
    rename_column :notes, :release_id, :report_id
    add_index :notes, :report_id
  end
end
