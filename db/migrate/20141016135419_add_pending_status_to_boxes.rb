class AddPendingStatusToBoxes < ActiveRecord::Migration
  def change
    add_column :boxes, :pending_status, :hstore
  end
end
