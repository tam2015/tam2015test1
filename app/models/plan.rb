# == Schema Information
#
# Table name: plans
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  price        :string(255)
#  collaborator :string(255)
#  dashboard    :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#

class Plan < ActiveRecord::Base
  has_many :subscriptions
end
