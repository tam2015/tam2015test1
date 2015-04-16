class UpdateItemStorages < ActiveRecord::Migration
  def change
    change_column :item_storages, :variation_id, :integer, limit: 8
  end
end
