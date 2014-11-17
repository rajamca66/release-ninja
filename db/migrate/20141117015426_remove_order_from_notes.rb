class RemoveOrderFromNotes < ActiveRecord::Migration
  def change
    remove_column :notes, :order, :integer
  end
end
