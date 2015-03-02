class RemoveColumnsInBoxes < ActiveRecord::Migration
  def change
    change_table :boxes do |t|
      t.remove(:document_file_name    ) if t.column_exists? :document_file_name
      t.remove(:document_content_type ) if t.column_exists? :document_content_type
      t.remove(:document_file_size    ) if t.column_exists? :document_file_size
      t.remove(:document_updated_at   ) if t.column_exists? :document_updated_at
      t.remove(:user_id               ) if t.column_exists? :user_id
      t.remove(:step_id               ) if t.column_exists? :step_id
    end
  end
end
