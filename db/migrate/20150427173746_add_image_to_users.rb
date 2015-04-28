class AddImageToUsers < ActiveRecord::Migration
  def change
    add_column :users, :image, :string
    add_column :users, :website, :string    
    add_column :users, :alternative_email, :string, limit: 8        
  end
end
