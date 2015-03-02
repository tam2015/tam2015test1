class UpdateBoxes < ActiveRecord::Migration
  def change
    #  status -> to_string
    change_column :boxes, :status, :string

    # item_pid -> meli_item_id, string limit(20)
    rename_column :boxes, :item_pid, :meli_item_id
    change_column :boxes, :meli_item_id, :string, {limit: 40}

    # REMOVE:
    #   data_status
    remove_column :boxes, :data_status, :integer
    #   payment_status
    remove_column :boxes, :payment_status, :integer
    #   shipping_status
    remove_column :boxes, :shipping_status, :integer
    #   ordely
    remove_column :boxes, :ordely, :boolean, {default: false}
    #   extras
    remove_column :boxes, :extras, :hstore
    #   position
    remove_column :boxes, :position, :integer
    #   pending
    remove_column :boxes, :pending, :string
    #   pending_status
    remove_column :boxes, :pending_status, :hstore
  end
end
