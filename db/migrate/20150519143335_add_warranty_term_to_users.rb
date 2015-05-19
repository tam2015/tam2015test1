class AddWarrantyTermToUsers < ActiveRecord::Migration
  def change
    add_column :users, :warranty_term, :text
  end
end
