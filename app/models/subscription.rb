# == Schema Information
#
# Table name: subscriptions
#
#  id                             :integer          not null, primary key
#  paypal_customer_token          :string(255)
#  paypal_recurring_profile_token :string(255)
#  account_id                     :integer
#  user_id                        :integer
#  plan_id                        :integer
#  created_at                     :datetime
#  updated_at                     :datetime
#  status                         :string(255)
#  expires_in                     :datetime
#

class Subscription < ActiveRecord::Base

  belongs_to :account
  belongs_to :plan
  has_many :payment_notifications

  #validates :plan_id, :paypal_payment_token,
   # presence: true,
    #:on => :update

  attr_accessor :paypal_payment_token

  def save_with_payment
    if valid?
      # if paypal_payment_token.present?
        save_with_paypal_payment
      # end
    end
  end

  def expired?
    !!(Time.now > expires_in) if expires_in?
  end

  def paypal
    PaypalPayment.new(self)
  end

  def save_with_paypal_payment
    response = paypal.make_recurring
    self.paypal_recurring_profile_token = response.profile_id
    save!
  end
end
