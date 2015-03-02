class CreateVariations < ActiveRecord::Migration
  def change
    create_table :variations do |t|
      t.integer :item_id
      t.float :price
      t.text :meli_picture_ids, array: true
      t.integer :meli_variation_id, limit: 8
      t.string  :seller_custom_field

      t.timestamps

    end
    add_index :variations, [:meli_variation_id]
  end
end
