class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.integer :item_id
      t.string :meli_id
      t.text :meli_url
      t.text :meli_secure_url
      t.string :meli_size
      t.string :meli_max_size
      t.string :quality
      t.text :source

      t.timestamps

    end
    add_index :pictures, [:meli_url]
  end
end
