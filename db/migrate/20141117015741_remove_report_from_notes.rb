class RemoveReportFromNotes < ActiveRecord::Migration
  def change
    remove_column :notes, :report_id, :integer
  end
end
