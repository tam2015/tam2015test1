class AddOrdelyToBoxes < ActiveRecord::Migration
  def change
    change_table :boxes do |t|
      t.boolean   :ordely, default: false
    end
    Box.all.each do |box|
      box.update ordely: false
    end
  end
end
