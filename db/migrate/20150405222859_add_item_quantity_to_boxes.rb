class AddItemQuantityToBoxes < ActiveRecord::Migration
  def change
    add_column :boxes, :item_quantity, :integer
  end
end
