class AddDefaultMarkdownBodyToNotes < ActiveRecord::Migration
  def change
    change_column :notes, :markdown_body, :text, null: false, default: ""
  end
end
