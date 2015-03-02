class AddTagsToBoxes < ActiveRecord::Migration
  def up
    add_column :boxes, :tags, :string, array: true

    Dashboard.all.includes(:boxes) do |dashboard|
      dashboard.boxes.all do |box|
        Mercadolibre::OrderWorker.perform_async dashboard.uid, box.pid
      end
    end
  end
  def down
    remove_column :boxes, :tags
  end
end
