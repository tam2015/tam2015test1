class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.string :rating
      t.integer :box_id

      t.timestamps
    end
  end
end
