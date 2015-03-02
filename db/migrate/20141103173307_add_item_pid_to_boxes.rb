class AddItemPidToBoxes < ActiveRecord::Migration
  def change
    add_column :boxes, :item_pid, :string
  end
end
