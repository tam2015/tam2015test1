class CreateSteps < ActiveRecord::Migration
  def change
    create_table :steps do |t|
      t.string  :name
      t.integer :position
      t.string  :color
      t.string  :status_param

      # Assosiations
      t.integer :dashboard_id
      t.integer :user_id

      t.timestamps
    end
  end
end
