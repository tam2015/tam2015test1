class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.integer :status
      t.integer :meli_payment_id, limit: 8
      t.integer :box_id
      t.integer :dashboard_id
      t.integer :meli_order_id, limit: 8
      t.integer :user_id
      t.boolean :accept_mercadopago, default: false
      t.string :tags, array: true
      t.string :payment_method_id
      t.integer :installments
      t.float :transaction_amount
      t.float :shipping_cost
      t.float :overpaid_amount
      t.float :total_paid_amount
      t.string :card_id

      t.timestamps

    end
    add_index :payments, [:meli_payment_id, :meli_order_id, :box_id]
  end
end
