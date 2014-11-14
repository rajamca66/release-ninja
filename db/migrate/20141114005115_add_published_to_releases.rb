class AddPublishedToReleases < ActiveRecord::Migration
  def change
    add_column :releases, :published, :boolean, default: false
  end
end
