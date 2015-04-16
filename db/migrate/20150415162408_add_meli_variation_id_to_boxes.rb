class AddMeliVariationIdToBoxes < ActiveRecord::Migration
  def change
    add_column :boxes, :meli_variation_id, :integer, limit: 8
    add_index  :boxes, [:meli_order_id, :meli_item_id]
  end
end
