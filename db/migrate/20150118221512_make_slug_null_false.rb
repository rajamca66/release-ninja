class MakeSlugNullFalse < ActiveRecord::Migration
  def up
    change_column :projects, :slug, :string, null: false
  end

  def down
    change_column :projects, :slug, :string, null: true
  end
end
