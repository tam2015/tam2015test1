class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.integer :status
      t.string :meli_item_id, limit: 15
      t.string :text
      t.integer :meli_question_id, limit: 8
      t.boolean :hold
      t.boolean :deleted_from_listing
      t.text :answer
      t.integer :dashboard_id
      t.integer :user_id
      t.integer :author_id, limit: 8
      t.integer :seller_id, limit: 8
      t.boolean :customer_blocked, default: false

      t.timestamps

    end
    add_index :questions, [:meli_question_id, :meli_item_id]
  end
end
