class CreateLabels < ActiveRecord::Migration
  def change
    create_table :labels do |t|
      t.string :aircrm_date_printed
      t.string :meli_first_date_printed
      t.integer :shipping_id
    end
  end
end
