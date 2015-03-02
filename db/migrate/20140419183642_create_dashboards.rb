class CreateDashboards < ActiveRecord::Migration
  def change
    create_table :dashboards do |t|
      t.string  :name

      # Omniauth
      t.string  :provider
      t.string  :uid
      t.string  :token
      t.string  :refresh_token
      t.string  :token_expires_at

      # Assosiations
      t.integer :account_id

      t.timestamps
    end
  end
end
