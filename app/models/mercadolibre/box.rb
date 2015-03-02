module Mercadolibre
  class Box
    include ActionView::Helpers::NumberHelper

    def initialize dashboard, *options

    end









    # Instance methods
    # ################
    def parse(record)
      # change multiple attributes
      record = set_associations(record)

      attrs = {
        meli_order_id:          record.id,
        name:         name(record),
        description:  description(record),
        meli_item_id:     record.order_items.first[:item][:id]
      }

      [ :status, :data_status, :payment_status, :shipping_status,
        :customer_id, :account_id, :dashboard_id, :tags
      ].each do |key|
        attrs[key] = record.send("#{key}?")
      end

      # return hash
      attrs.merge!({
        created_at:       record.date_created?,
        closed_at:        record.date_last_updated?,
        price:            record.total_amount?,
      })
    end

    def update_record(record, opts={})
      box = ::Box.where(meli_order_id: record.id).first_or_initialize

      hash = parse record

      hash[:status] = :archived if difference_in_days(Time.parse(record.date_created)) > 21.days

      updated = box.update(hash)

      set_has_associations record, box

      @records << record
      @boxes   << box
      box
    end











    # Helpers
    def difference_in_days(end_date, start_date = Time.current)
      start_date.end_of_day - end_date.beginning_of_day
    end

    def self.destroy(box)
      # Answer.where(meli_order_id: box.meli_order_id).destroy_all
      # Question.where(meli_order_id: box.meli_order_id).destroy_all
      # ::Feedback.where(meli_order_id: box.meli_order_id).destroy_all
      ::Mercadolibre::Shipping.where(meli_order_id: box.meli_order_id).destroy_all
    end

  end

end
