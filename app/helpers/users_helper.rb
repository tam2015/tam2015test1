module UsersHelper
  # Devise resources
  def resource_name
    :user
  end

  def resource_class
    devise_mapping.to
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end



  # Event Tracker
  def mixpanel_distinct_id
    current_user && current_user.id
  end

  def mixpanel_name_tag
    current_user && current_user.email
  end

  def kissmetrics_identity
    current_user && current_user.email
  end

  # Admin_User_Table
  def subscription_date_expiration(user)
    date = user.subscriptions.first.expires_in if user.subscriptions.present?
  end

  def subscription_date_expiration
    if current_account && current_account.subscription.present? && current_account.subscription.expires_in
      current_account.subscription.expires_in.utc.iso8601
    end
  end

end
