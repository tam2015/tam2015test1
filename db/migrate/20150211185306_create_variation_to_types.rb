class CreateVariationToTypes < ActiveRecord::Migration
  def change
    create_table :variation_to_types do |t|
      t.integer  :variation_type_id
      t.integer  :variation_id

      t.timestamps

    end
  end
end
