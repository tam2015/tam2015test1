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
#

require 'test_helper'

class SubscriptionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
