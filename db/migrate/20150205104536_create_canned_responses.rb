class CreateCannedResponses < ActiveRecord::Migration
  def change
    create_table :canned_responses do |t|
      t.text :answer
      t.string :tag
      t.integer :account_id
      t.integer :dashboard_id

      t.timestamps
    end
  end
end
