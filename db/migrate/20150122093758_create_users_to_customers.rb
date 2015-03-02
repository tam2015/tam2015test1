class CreateUsersToCustomers < ActiveRecord::Migration
  def change
    create_table :users_to_customers do |t|
      t.integer :customer_id
      t.integer :user_id
      t.boolean :blocked_to_questions, default: :false

      t.timestamps
    end
  end
end
