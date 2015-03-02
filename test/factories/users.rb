# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  first_name             :string(255)
#  last_name              :string(255)
#  username               :string(255)
#  phone                  :string(255)
#  role                   :string(255)      default("regular")
#  account_id             :integer
#  created_at             :datetime
#  updated_at             :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    name "User"
    email "user1@example.com"
    password "12345678"
    password_confirmation "12345678"
    phone "1234567890"
  end
end
