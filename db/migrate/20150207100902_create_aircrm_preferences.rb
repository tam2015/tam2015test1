class CreateAircrmPreferences < ActiveRecord::Migration
  def change
    create_table :aircrm_preferences do |t|
      t.string :preference_type
      t.text :data
      t.integer :account_id
      t.integer :dashboard_id

      t.timestamps
    end
  end
end
