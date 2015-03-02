class UpdateIdentities < ActiveRecord::Migration
  def change
    # uid -> meli_user_id, to_i
    rename_column :identities, :uid, :meli_user_id
    change_column :identities, :meli_user_id, "integer USING NULLIF(meli_user_id, '')::int"
  end
end
