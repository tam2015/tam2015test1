class UpdateCustomer < ActiveRecord::Migration
  def change
    # ml_id -> meli_user_id
    rename_column :customers, :ml_id, :meli_user_id
  end
end
