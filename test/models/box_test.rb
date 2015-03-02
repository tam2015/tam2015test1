# == Schema Information
#
# Table name: boxes
#
#  id                    :integer          not null, primary key
#  name                  :string(255)
#  description           :text
#  position              :integer
#  closed                :boolean          default(FALSE)
#  price                 :decimal(, )
#  status                :string(255)
#  favorite              :boolean          default(FALSE)
#  document_file_name    :string(255)
#  document_content_type :string(255)
#  document_file_size    :integer
#  document_updated_at   :datetime
#  account_id            :integer
#  customer_id           :integer
#  dashboard_id          :integer
#  step_id               :integer
#  user_id               :integer
#  created_at            :datetime
#  updated_at            :datetime
#  ordely                :boolean          default(FALSE)
#  pid                   :string(255)
#  extras                :hstore
#

require 'test_helper'

class BoxTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
