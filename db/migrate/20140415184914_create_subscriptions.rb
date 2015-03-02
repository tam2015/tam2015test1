class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.string :paypal_customer_token
      t.string :paypal_recurring_profile_token

      # Assosiations
      t.integer :account_id
      t.integer :user_id
      t.integer :plan_id

      t.timestamps
    end
  end
end
