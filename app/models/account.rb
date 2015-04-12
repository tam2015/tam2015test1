# == Schema Information
#
# Table name: accounts
#
#  id          :integer          not null, primary key
#  created_at  :datetime
#  updated_at  :datetime
#  boxes_count :integer          default(0), not null
#

class Account < ActiveRecord::Base
  include AccountsHelper

  has_many :dashboards
  has_many :users
  has_many :boxes
  has_many :items, class: Mercadolibre::Item
  has_one :subscription
  # has_many :owners                , foreign_key: "owner_of_account_id", class_name: "User"
  has_many :payment_notifications
  has_many :customers
  has_many :aircrm_preferences

  after_create :trial_subscription   #create a subscription with status == trial to the account

  scope :with_subscription, -> { includes(:subscription) }

  # User.current
  def self.current
    Thread.current[:account]
  end

  def self.current=(account)
    Thread.current[:account] = account
  end

  def self.last_payment_notification(account)
    unless account.payment_notifications.empty?
      @last_payment_notification = account.payment_notifications.last.created_at
    end
  end

  def self.next_payment_notification(account)
    unless account.payment_notifications.empty?
      @last_payment_notification = account.payment_notifications.last.created_at
    end
  end

  def self.reset_boxes_counter!
    self.all.each do |account|
      account.update(boxes_count: (account.boxes.count || 0))
    end
  end

  def expires_in
    if subscription
      subscription.expires_in
    else
      I18n.l 0.days
    end
  end

  def trial_period_date
    #Time.now + (eval(ENV["TRIAL_PERIOD"]) || 14.days)
    Time.now + 14.days
  end

  def trial_subscription
    subscription = Subscription.new({
      status: "trial",
      account_id: self.id,
      expires_in: trial_period_date
      })
    subscription.save!
  end
end
