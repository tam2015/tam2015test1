class AddManualVariationToBoxes < ActiveRecord::Migration
  def change
    add_column :boxes, :manual_variation, :text
  end
end
