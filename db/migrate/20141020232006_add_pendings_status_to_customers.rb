class AddPendingsStatusToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :pendings_status, :string
    add_column :customers, :pendings, :string, array: true
  end
end
