# This model has the purpose of collection Users data
# to better determine data algorithms flows
# Consists on store data as JSON type of several API requests
# application make to sync Mercadolibre's users accounts

class DataStore
  include Mongoid::Document
  include Mongoid::Timestamps

  field :from,  type: String
  field :klass, type: String
  field :meli_id, type: String
  field :json,  type: Hash
end

# # AccountSync.add_to_collection (Orders) ✔
# :account_sync_partial_order, Meli::Order, meli_order.json ??

# # ItemWorker ✔
# :meli_item, Meli::Item, meli_item.json

# # Question.rb ✔
# :meli_item_question, Meli::Question, meli_order.json

# # Payment parse
# :meli_order_payment, Meli::Order::Payment, meli_order.json

# # Shipping parse
# :meli_order_payment, Meli::Order::Shipping, meli_order.json

# # Feedback parse
# :meli_order_payment, Meli::Order::Feedback, meli_order.json

# # Customer parse
# :meli_order_customer, Meli::Order::Customer, meli_order.json
