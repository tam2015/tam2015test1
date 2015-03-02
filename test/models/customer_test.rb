# == Schema Information
#
# Table name: customers
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  nickname   :string(255)
#  phone      :string(255)
#  email      :string(255)
#  ml_id      :integer
#  user_id    :integer
#  account_id :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'test_helper'

class CustomerTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
