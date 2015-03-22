class AddMeliDateFieldsToModels < ActiveRecord::Migration
  def up
    remove_column :meli_infos, :meli_start_time
    remove_column :meli_infos, :meli_stop_time
    remove_column :meli_infos, :meli_end_time
    remove_column :meli_infos, :meli_last_updated

    add_column :meli_infos, :meli_start_time, :string
    add_column :meli_infos, :meli_stop_time, :string
    add_column :meli_infos, :meli_end_time, :string
    add_column :meli_infos, :meli_last_updated, :string

    add_column :boxes, :meli_date_created, :string
    add_column :boxes, :meli_date_closed, :string
    add_column :boxes, :meli_last_updated, :string

    add_column :questions, :meli_date_created, :string

    add_column :feedbacks, :meli_date_created, :string


  end
end
