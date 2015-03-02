class CreateNotifyAgents < ActiveRecord::Migration
  def change
    create_table :notify_agents do |t|
      t.string :first_name
      t.string :last_name
      t.string :full_name
      t.string :nickname
      t.string :email
      t.string :phone
      t.integer :meli_user_id
      t.string :type
      t.integer :notify_id

      t.timestamps

    end
  end
end
