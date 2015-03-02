class CreateShippings < ActiveRecord::Migration
  def change
    create_table :shippings do |t|
      t.integer :meli_shipping_id, limit: 8
      t.integer :status
      t.integer :shipment_type
      t.string :shipping_mode
      t.string :substatus
      t.string :currency_id
      t.string :cost
      t.string :date_first_printed
      t.string :service_id
      t.string :receiver_address_s
      t.text :receiver_address
      t.string :coordinates, array: true
      t.text :sender_address
      t.string :tracking_number
      t.string :tracking_method
      t.string :return_tracking_number
      t.time :updated_by_buyer_at
      t.integer :box_id
      t.integer :dashboard_id
      t.string :meli_item_id, limit: 15
      t.integer :meli_order_id, limit: 8
      t.integer :user_id
      t.string :pendings, array: true
      t.string :pendings_status
      t.boolean :updated_by_seller, default: false
      t.boolean :updated_by_customer, default: false
      t.boolean :accept_mercadoenvios, default: false
      t.string :tags, array: true
      t.string :date_shipped
      t.string :date_delivered
      t.float :cost

      t.timestamps

    end
    add_index :shippings, [:meli_order_id, :box_id]
  end
end
