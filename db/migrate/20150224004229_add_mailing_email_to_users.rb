class AddMailingEmailToUsers < ActiveRecord::Migration
  def change
    add_column :users, :mailing_email, :string
  end
end
