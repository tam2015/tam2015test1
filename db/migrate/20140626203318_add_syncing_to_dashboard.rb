class AddSyncingToDashboard < ActiveRecord::Migration
  def change
    add_column :dashboards, :synced_at, :datetime
  end
end
