class AddBillingInfoToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :billing_info, :text
  end
end
