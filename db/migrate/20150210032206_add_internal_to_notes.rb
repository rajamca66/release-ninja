class AddInternalToNotes < ActiveRecord::Migration
  def change
    add_column :notes, :internal, :boolean, default: false
  end
end
