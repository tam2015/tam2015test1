# class RedactorRails::Asset
#   include Mongoid::Document
#   include Mongoid::Timestamps

#   include RedactorRails::Orm::Mongoid::AssetBase

#   field :account_id   , type: Integer

#   delegate :url, :current_path, :size, :content_type, :filename, :to => :data
#   validates_presence_of :data

#   before_save :set_account_id

#   def set_account_id
#     self.account_id= Account.current.id
#   end
# end
