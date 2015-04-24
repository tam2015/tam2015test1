class Notify < ActiveRecord::Base

  enum param: [ :no_address, :no_feedback ]#, default: nil

  enum delivery_method: [:email, :sms]#, multiple: true#, default: [:email]

  enum status: [ :saved, :delivered, :bounced, :updated, :cancelled, :arquived ]

  has_one :sender, class_name: :NotifyAgent
  has_one :receiver, class_name: :NotifyAgent

  #validates :reference_id, :reference_model, :receiver, presence: true
  # validates :reference_id, :reference_model, :param, :receiver, presence: true


  alias_attribute :date_created, :created_at

  # Callbacks
  after_create :notify!


  def notify!
    # if param == 0
    #   # Mailing::Notify.delay(queue: :seldom, retry: false).no_address(self.id)
    #   Mailing::Notify.no_address(id).deliver
    # elsif param == 1
    #   # Mailing::Notify.delay(queue: :seldom, retry: false).no_address(self.id)
      Mailing::Notify.no_feedback(id).deliver
    # end
  end
end
