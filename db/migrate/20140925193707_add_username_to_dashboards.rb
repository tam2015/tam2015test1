class AddUsernameToDashboards < ActiveRecord::Migration
  def change
    add_column :dashboards, :username, :string
  end
end
