class AddAllStatusToBoxes < ActiveRecord::Migration
  def change
    # remove status to change column type
    remove_column :boxes, :status , :integer, default: 0

    # *status
    add_column :boxes, :shipping_status , :integer, default: 0
    add_column :boxes, :payment_status  , :integer, default: 0
    add_column :boxes, :data_status     , :integer, default: 0
    add_column :boxes, :status          , :integer, default: 0

    add_column :boxes, :closed_at       , :datetime

  end
end
