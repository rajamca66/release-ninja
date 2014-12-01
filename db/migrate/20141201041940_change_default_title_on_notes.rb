class ChangeDefaultTitleOnNotes < ActiveRecord::Migration
  def change
    change_column :notes, :title, :text, null: false, default: ""
  end
end
