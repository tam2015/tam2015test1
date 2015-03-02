class CreateMeliInfos < ActiveRecord::Migration
  def change
    create_table :meli_infos do |t|
      t.integer :item_id
      t.boolean :accepts_mercadopago
      t.text :non_mercado_pago_payment_methods
      t.text :shipping, default: {
        mode:           "not_specified",
        local_pick_up:  false,
        free_shipping:  false,
        methods:        [],
        costs:          [],
        dimensions:     nil,
      }
      t.text :seller_address
      t.text :geolocation

      t.integer :validation_code
      t.string :validation_status, default: :invalid
      t.string :validation_errors, array: true
      t.string :site_id
      t.string :currency_id, default: "BRL"
      t.string :permalink
      t.string :thumbnail
      t.string :secure_thumbnail

      t.datetime :meli_start_time
      t.datetime :meli_stop_time
      t.datetime :meli_end_time
      t.datetime :meli_last_updated


      t.timestamps

    end
  end
end

#removed attrs
#t.text :seller_contact
#t.text :coverage_areas, array: true, default: []
#t.string :tags, array: true
#t.text :location
#t.string :shipping_options -> it seems that it doesn't exists
