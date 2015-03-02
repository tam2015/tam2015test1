# == Schema Information
#
# Table name: dashboards
#
#  id               :integer          not null, primary key
#  name             :string(255)
#  provider         :string(255)
#  uid              :string(255)
#  token            :string(255)
#  refresh_token    :string(255)
#  token_expires_at :string(255)
#  account_id       :integer
#  created_at       :datetime
#  updated_at       :datetime
#  synced_at        :datetime
#  preferences      :hstore
#

require 'test_helper'

class DashboardTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
