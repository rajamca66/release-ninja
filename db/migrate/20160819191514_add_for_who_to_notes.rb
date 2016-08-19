class AddForWhoToNotes < ActiveRecord::Migration
  def change
    add_column :notes, :for_who, :string
  end
end
