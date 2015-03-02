class CreateItemStorages < ActiveRecord::Migration
  def change
    create_table :item_storages do |t|
      t.integer :initial_quantity
      t.integer :available_quantity
      t.integer :sold_quantity
      t.integer :unpublished_quantity
      t.integer :item_id
      t.integer :variation_id

      t.timestamps

    end
    add_index :item_storages, [:variation_id]
  end
end
