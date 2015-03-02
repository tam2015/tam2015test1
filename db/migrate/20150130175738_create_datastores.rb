class CreateDatastores < ActiveRecord::Migration
  def change
    create_table :datastores do |t|
      t.string :from
      t.string :klass
      t.string :meli_id
      t.text :json
    end
  end
end
