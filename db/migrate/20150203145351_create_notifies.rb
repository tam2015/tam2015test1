class CreateNotifies < ActiveRecord::Migration
  def change
    create_table :notifies do |t|
      t.integer :param
      t.integer :delivery_method
      t.integer :status
      t.time :email_delivered_at
      t.time :sms_delivered_at
      t.integer :dashboard_id
      t.integer :box_id
      t.integer :meli_order_id
      t.string :reference_id
      t.string :reference_model

      t.timestamps

    end
  end
end
