class AddCountersToUsers < ActiveRecord::Migration
  def change
    add_column :accounts  , :boxes_count      , :integer, default: 0, null: false
    add_column :dashboards, :boxes_count      , :integer, default: 0, null: false
    add_column :users     , :dashboards_count , :integer, default: 0, null: false

    User.reset_dashboards_counter!
    Account.reset_boxes_counter!
    Dashboard.reset_boxes_counter!
  end
end
