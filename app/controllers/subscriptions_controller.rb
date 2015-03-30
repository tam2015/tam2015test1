class SubscriptionsController < ApplicationController
  layout "home"
  before_action :authenticate_user!
  skip_before_filter :check_subscription_expired

  def index
    @subscriptions = Subscription.all
  end

  def edit
    @subscription = Subscription.where(account_id: current_account.id).first
    @plan = Plan.find(params[:plan_id]) 
    @subscription = @plan.subscriptions.build
  end

  def update
    subscription_change_params = {
      user_id:    current_user.id,
      account_id: current_account.id,
      status: "Completed"
    }.reverse_merge subscription_params

    @subscription = Subscription.where(:account_id => current_account.id).first_or_initialize

    subscription_change_params.each do |k, v|
      @subscription.send("#{k}=", v)
    end

    Rails.logger.debug "#{@subscription.to_json}"
    if @subscription.save_with_payment
      redirect_to dashboards_path, :notice => "Thank you for subscribing!"
      Mailing::Subscription.subscription_confirmation(@subscription).deliver
    else
      render :new
    end
  end


  def checkout
    @plan = Plan.find(params[:plan_id])
    subscription = @plan.subscriptions.build
    redirect_to subscription.paypal.checkout_url(
      return_url: edit_subscription_url(:id, :plan_id => @plan.id),
      cancel_url: root_url
    )
  end

    # Never trust parameters from the scary internet, only allow the white list through.
  def subscription_params
    params.require(:subscription).permit(:paypal_customer_token, :paypal_payment_token, :paypal_recurring_profile_token,
      # Assosiations
      :account_id, :user_id, :plan_id )
  end
end
