# == Schema Information
#
# Table name: users_to_dashboards
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  dashboard_id :integer
#  role         :string(255)      default("owner")
#  created_at   :datetime
#  updated_at   :datetime
#

class UsersToDashboard < ActiveRecord::Base
  belongs_to :user
  belongs_to :dashboard
end
