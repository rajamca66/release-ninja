class MigrateLevelToNewFormat < ActiveRecord::Migration
  def up
    Note.where(level: "major").update_all(level: "feature")
    Note.where(level: "minor").update_all(level: "feature")
  end

  def down
  end
end
