class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text    :content

      # Assosiations
      t.integer :user_id
      t.string  :box_id

      t.timestamps
    end
  end
end
