class RemoveMlToBoxes < ActiveRecord::Migration
  def change
    change_table :boxes do |t|
      t.remove(:ml_order_id         ) if t.column_exists? :ml_order_id
      t.remove(:ml_shipping_address ) if t.column_exists? :ml_shipping_address
      t.remove(:ml_shipping_cost    ) if t.column_exists? :ml_shipping_cost
      t.remove(:ml_shipping_status  ) if t.column_exists? :ml_shipping_status
    end
  end
end
