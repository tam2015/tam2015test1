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

class Schedule < ActiveRecord::Base

  belongs_to :user

end
