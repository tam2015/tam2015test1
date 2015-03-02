class UpdateDashboard < ActiveRecord::Migration
  def change
    # provider -> string limit(20)
    change_column :dashboards, :provider, :string, {limit: 20}
    # uid -> meli_user_id, to_i
    rename_column :dashboards, :uid, :meli_user_id
    change_column :dashboards, :meli_user_id, "integer USING NULLIF(meli_user_id, '')::int"

    # username -> meli_user_username, string limit(40)
    rename_column :dashboards, :username, :meli_user_username
    change_column :dashboards, :meli_user_username, :string, {limit: 40}
  end
end
