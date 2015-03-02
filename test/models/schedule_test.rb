# == Schema Information
#
# Table name: schedules
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  address    :string(255)
#  note       :text
#  date_time  :datetime
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'test_helper'

class ScheduleTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
