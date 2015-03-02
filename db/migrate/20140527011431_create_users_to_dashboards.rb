class CreateUsersToDashboards < ActiveRecord::Migration
  def change
    create_table :users_to_dashboards do |t|
      t.references  :user       , index: true
      t.references  :dashboard  , index: true
      t.string      :role       , default: "owner"

      t.timestamps
    end
  end
end
