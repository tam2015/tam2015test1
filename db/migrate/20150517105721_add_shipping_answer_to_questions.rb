class AddShippingAnswerToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :shipping_answer, :text
  end
end
