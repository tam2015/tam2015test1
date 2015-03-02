class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.string :rating
      t.boolean :fulfilled
      t.string :reason
      t.string :message
      t.string :reply
      t.string :status
      t.string :author_type
      t.integer :meli_feedback_id, limit: 8
      t.string :meli_item_id, limit: 15
      t.integer :meli_order_id, limit: 8
      t.integer :dashboard_id
      t.boolean :updated, default: false
      t.boolean :restock_item, default: false

      t.timestamps

    end
    add_index :feedbacks, [:meli_order_id, :author_type]
  end
end
