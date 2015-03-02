class AddPendingToBoxes < ActiveRecord::Migration
  def change
    add_column :boxes, :pending, :string, array: true
  end
end
