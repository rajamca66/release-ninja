class CreateConvertedComments < ActiveRecord::Migration
  def change
    create_table :converted_pull_requests do |t|
      t.references :note, index: true, null: false
      t.references :project, index: true, null: false
      t.integer :pull_request_id, null: false

      t.timestamps
    end

    add_index :converted_pull_requests, :pull_request_id
  end
end
