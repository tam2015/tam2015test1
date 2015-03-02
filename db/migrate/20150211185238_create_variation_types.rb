class CreateVariationTypes < ActiveRecord::Migration
  def change
    create_table :variation_types do |t|
      t.string :meli_id
      t.string  :meli_name
      t.string  :meli_value_id
      t.string  :meli_value_name

      t.timestamps

    end
    add_index :variation_types , [:meli_id]
  end
end
