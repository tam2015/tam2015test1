class RenameIdentityUsername < ActiveRecord::Migration
    def change
      rename_column :identities, :username, :meli_user_username
    end
  end
