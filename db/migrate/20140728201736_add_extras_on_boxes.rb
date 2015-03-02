class AddExtrasOnBoxes < ActiveRecord::Migration
  def change
    add_column :boxes, :pid, :string
    add_column :boxes, :extras, :hstore

    add_index :boxes, :extras, using: :gist

    # change_table :boxes do |t|
    #   t.remove(:ml_order_id, :ml_shipping_address, :ml_shipping_cost, :ml_shipping_status)
    # end
  end
end
