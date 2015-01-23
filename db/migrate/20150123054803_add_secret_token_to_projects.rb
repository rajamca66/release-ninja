class AddSecretTokenToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :secret_token, :string
  end
end
