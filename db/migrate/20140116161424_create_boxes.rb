class CreateBoxes < ActiveRecord::Migration
  def change
    create_table :boxes do |t|
      t.string    :name
      t.text      :description
      t.integer   :position
      t.boolean   :closed, default: false
      t.decimal   :price
      t.string    :status
      t.boolean   :favorite, default: false

      # Attachments
      # t.attachment :document

      # Mercadolibre
      # t.integer :ml_order_id
      # t.text    :ml_shipping_address
      # t.decimal :ml_shipping_cost
      # t.string  :ml_shipping_status

      # Assosiations
      t.integer :account_id
      t.integer :customer_id
      t.integer :dashboard_id
      # t.integer :step_id
      # t.integer :user_id

      t.timestamps
    end
  end
end
