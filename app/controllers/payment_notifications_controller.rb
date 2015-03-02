class PaymentNotificationsController < ApplicationController
  protect_from_forgery :except => [:create]

  before_action :set_payment_notification, only: [:show, :edit, :update, :destroy]



  # POST /payment_notifications
  # POST /payment_notifications.json
  def create
    subscription = Subscription.where(:paypal_customer_token => params[:payer_id]).first
    subscription.update(:status => params[:payment_status]) if subscription
    account_id = subscription.account_id

    PaymentNotification.create!({
      params:                 params,
      status:                 params[:payment_status],
      transaction_id:         params[:txn_id],
      paypal_customer_token:  params[:payer_id],
      account_id:             account_id,
      subscription_id:        subscription.id
    })

    render :nothing => true
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_payment_notification
      @payment_notification = PaymentNotification.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def payment_notification_params
      params.require(:payment_notification).permit(:params, :status, :transaction_id, :paypal_customer_token,
      # Assosiations
        :account_id, :user_id, :subscription_id)
    end
end
