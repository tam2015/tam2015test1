class AddExpiresInToSubscription < ActiveRecord::Migration
  def change
    add_column :subscriptions, :expires_in, :datetime
  end
end
