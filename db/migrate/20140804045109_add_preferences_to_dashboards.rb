class AddPreferencesToDashboards < ActiveRecord::Migration
  def change
    add_column :dashboards, :preferences, :hstore
  end
end
