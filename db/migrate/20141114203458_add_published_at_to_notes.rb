class AddPublishedAtToNotes < ActiveRecord::Migration
  def change
    add_column :notes, :published_at, :timestamp
  end
end
