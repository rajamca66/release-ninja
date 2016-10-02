class CreateUserReadingLocations < ActiveRecord::Migration
  def change
    create_table :user_reading_locations do |t|
      t.string :user_key, null: false
      t.datetime :reading_location, null: false
      t.belongs_to :project, index: true, null: false

      t.timestamps null: false
    end

    add_index :user_reading_locations, [:user_key, :project_id], unique: true
  end
end
