# == Schema Information
#
# Table name: identities
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  provider     :string(255)
#  meli_user_id :integer
#  created_at   :datetime
#  updated_at   :datetime
#  username     :string(255)
#

class Identity < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :meli_user_id, :provider
  validates_uniqueness_of :meli_user_id, scope: :provider

  def self.find_for_oauth(auth)
    identity = self.where(meli_user_id: auth.uid, provider: auth.provider).first_or_initialize do |identity|
      identity.meli_user_username   = auth.info.username
      identity.save
    end
  end
end
