class AddDetailsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :address, :hstore
    add_column :users, :codigo, :string
    add_column :users, :filial, :string
    add_column :users, :razaosocial, :string
    add_column :users, :fantasia, :string
    add_column :users, :cnpj, :string
    add_column :users, :telefone, :hstore
    add_column :users, :tipo_cliente, :string
    add_column :users, :id_brands, :hstore
  end
end
