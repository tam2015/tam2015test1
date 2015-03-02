# == Schema Information
#
# Table name: payment_notifications
#
#  id                    :integer          not null, primary key
#  params                :text
#  status                :string(255)
#  transaction_id        :string(255)
#  paypal_customer_token :string(255)
#  account_id            :integer
#  user_id               :integer
#  created_at            :datetime
#  updated_at            :datetime
#  subscription_id       :integer
#

class PaymentNotification < ActiveRecord::Base

  serialize :params

  belongs_to :account

  belongs_to :subscription


end
