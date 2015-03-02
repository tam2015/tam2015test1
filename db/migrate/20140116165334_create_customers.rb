class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :name
      t.string :nickname
      t.string :phone
      t.string :email

      # Mercadolivre
      t.integer :ml_id

      # Assosiations
      t.integer :user_id
      t.integer :account_id

      t.timestamps
    end
  end
end
