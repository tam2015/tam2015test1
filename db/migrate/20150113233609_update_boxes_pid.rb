class UpdateBoxesPid < ActiveRecord::Migration
  def change
    rename_column :boxes, :pid, :meli_order_id
    change_column :boxes, :meli_order_id, "integer USING NULLIF(meli_order_id, '')::int"
  end
end
