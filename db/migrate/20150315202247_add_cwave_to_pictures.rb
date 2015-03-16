class AddCwaveToPictures < ActiveRecord::Migration
  def change
    add_column :pictures, :cwave, :text
  end
end
