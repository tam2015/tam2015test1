class Notification
  include Provider::ModelBase
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Enum

  enum :status, [:pending, :approved, :declined]

  ### Associations

  field :dashboard_id , type: Integer
  field :user_id      , type: Integer
  field :customer_id  , type: Integer

  alias_attribute :date_created, :created_at

end
