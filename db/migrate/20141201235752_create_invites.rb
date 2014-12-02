class CreateInvites < ActiveRecord::Migration
  def change
    create_table :invites do |t|
      t.references :user, index: true, null: false
      t.string :code, null: false
      t.references :team, index: true, null: false
      t.string :to, null: false
      t.boolean :redeemed, null: false, default: false

      t.timestamps
    end
  end
end
