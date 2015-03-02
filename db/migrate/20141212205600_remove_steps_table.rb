class RemoveStepsTable < ActiveRecord::Migration
  def change
    drop_table :steps
  end
end
