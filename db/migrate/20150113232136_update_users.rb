class UpdateUsers < ActiveRecord::Migration
  def change
    # username -> meli_user_username, string limit(40)
    rename_column :users, :username, :meli_user_username
    change_column :users, :meli_user_username, :string, {limit: 40}
  end
end
