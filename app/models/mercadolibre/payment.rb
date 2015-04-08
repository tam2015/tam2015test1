module Mercadolibre
  class Payment < ActiveRecord::Base
    include Provider::ModelBase


    # associations
    belongs_to :box

    #Dúvidas
    #include Geocoder::Model::Mongoid

    # payment status. Possible values:
      # to_be_agreed: address nil
      # pending: Pending to be shipped, not yet paid.
      # handling:  Ready to be shipped. When the payment become active.
      # shipped: Shipped.
      # delivered: Delivered. Automatic update with the shipment tracking number.
      # not_delivered: Not delivered. Automatic update with the shipment tracking number.
      # cancelled: Cancelled by sender or receiver.
    enum status: [ :to_be_agreed, :pending, :approved, :in_process, :rejected, :cancelled, :refunded, :in_mediation,:charged_back ]


    ##
    # Parse Payment information from Order
    #   @meli_order   {Meli::Order}
    #   @box          {Marcadolibre::Box}
    #
    # Check app-docs/meli-partial-order.json
    # to preview Meli::Order data structure
    def self.parse(meli_order, box)

      puts "* Mercadolibre::Payment.parse..."

      # has any payments?
      unless meli_order.payments.empty?

        # An Order can have more than 1 payment
        meli_order.payments.map do |meli_order_payment|

          # Rescue or Initialize a payment for payment_id (meli_order_id) and order_id
          payment = ::Mercadolibre::Payment.where(meli_payment_id: meli_order_payment.id, meli_order_id: meli_order.id).first_or_initialize

          # Associations
          payment.dashboard_id          = box.dashboard_id
          payment.meli_order_id         = meli_order.id
          payment.box_id                = box.id

          payment.status                = meli_order_payment.status || :to_be_agreed
          payment.accept_mercadopago    = true
          payment.payment_method_id     = meli_order_payment.payment_method_id?
          payment.installments          = meli_order_payment.installments?
          payment.shipping_cost         = meli_order_payment.shipping_cost?
          payment.transaction_amount    = meli_order_payment.transaction_amount?
          payment.overpaid_amount       = meli_order_payment.overpaid_amount?
          payment.total_paid_amount     = meli_order_payment.total_paid_amount?
          payment.card_id               = meli_order_payment.card_id?

          if payment.save
            # This is broken.
            box.update_tags_from_payment_changes box, payment, params=nil
          end

          # Data Collection for post analysis
          # Datastores.create!(from: :meli_order_payment,
          #                   meli_id: meli_order_payment.id,
          #                   klass: meli_order_payment.class,
          #                   json: meli_order_payment.serializable_hash)
        end

      # no payment associated yet
      else
        payment = ::Mercadolibre::Payment.where(meli_order_id: meli_order.id).first_or_initialize
        # Associations
        payment.dashboard_id          = box.dashboard_id
        payment.meli_order_id         = meli_order.id
        payment.box_id                = box.id
        payment.status              = :to_be_agreed
        payment.accept_mercadopago  = false
        payment.save
      end

    end

  end

end
