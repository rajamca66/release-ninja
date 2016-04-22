class AddIndexToPublishedNotes < ActiveRecord::Migration
  def change
    add_index :notes, :published
  end
end
