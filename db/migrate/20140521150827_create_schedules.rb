class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.string  :title
      t.string  :address
      t.text    :note

      t.datetime :date_time

      # Assosiations
      t.integer :user_id

      t.timestamps
    end
  end
end
