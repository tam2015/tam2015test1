class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.string :name
      t.string :price
      t.string :collaborator
      t.string :dashboard

      t.timestamps
    end
  end
end
