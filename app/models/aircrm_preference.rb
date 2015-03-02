class AircrmPreference < ActiveRecord::Base
  serialize :data

  belongs_to :account
  belongs_to :dashboard




end
