class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.integer :buying_mode
      t.string :category_id
      t.string :condition
      t.string :title
      t.text :description
      t.string :warranty
      t.float :price
      t.float :base_price
      t.string :video_id
      t.integer :listing_type_id

      t.integer :status
      t.string :seller_custom_field
      t.boolean :automatic_relist, default: false
      t.integer :dashboard_id
      t.integer :account_id
      t.string :meli_item_id, limit: 15
      t.string :official_store_id


      t.timestamps

    end
    add_index :items, [:meli_item_id, :status]
  end
end

#removed
#t.string :sub_status, array: true
#t.text :differential_pricing
#t.string :attributes_ajusted, array: true
#t.string :listing_source
#t.string :parent_item_id
#t.string :catalog_product_id
#t.string :meli_pictures, array: true
#t.float :original_price
#t.string :descriptions, array: true
