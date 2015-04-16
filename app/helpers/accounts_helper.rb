module AccountsHelper

  def current_account
    if user_signed_in?
      current_user.create_account unless current_user.account_id?
      @current_account ||= current_user.account
    end
  end

  def user_account_owner?
    user_signed_in? and current_user.account_id == current_account.id
  end


  def current_subscription
    current_account && current_account.subscription
  end

  def subscription_status(subscription = nil)
    subscription ||= (self.is_a?(Account) ? self.subscription : current_subscription)
    subscription.status.to_sym
  end

  def check_subscription_expired(subscription = nil)
    if user_signed_in?
      subscription ||= current_subscription
      if subscription and subscription.expired? and subscription.status !=  "Completed"
        redirect_to plans_path
      end
    end
  end



  # Trial
  def account_trial?
    if user_signed_in?
      if current_account and current_subscription
        if subscription_status == :trial and !current_subscription.expires_in?
          current_subscription.update(expires_in: trial_period_end)
        end

        subscription_status == :trial
      else
        raise ArgumentError, "Invalid account element.\n account=`#{current_account}`."
      end
    end
  end

  def trial_period_end
    #Time.now + (eval(ENV["TRIAL_PERIOD"]) || 14.days)
    Time.now + 14.days
  end

  def trial_period_remaining_days
    (trial_period_end.to_date - Date.today).round
  end

end
