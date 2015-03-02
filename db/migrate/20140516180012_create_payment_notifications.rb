class CreatePaymentNotifications < ActiveRecord::Migration
  def change
    create_table :payment_notifications do |t|
      t.text    :params
      t.string  :status
      t.string  :transaction_id
      t.string  :paypal_customer_token

      # Assosiations
      t.integer :account_id
      t.integer :user_id

      t.timestamps
    end
  end
end
