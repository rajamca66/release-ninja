class AddFilterToNotes < ActiveRecord::Migration
  def change
    add_column :notes, :filter, :string, default: "github", null: false
    add_index :notes, :filter
  end
end
