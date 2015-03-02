class AddSubscriptionIdToPaymentNotifications < ActiveRecord::Migration
  def change
    add_column :payment_notifications, :subscription_id, :integer
  end
end
