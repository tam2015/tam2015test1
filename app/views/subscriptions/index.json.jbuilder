json.array!(@subscriptions) do |subscription|
  json.extract! subscription, :id, :paypal_customer_token, :paypal_recurring_profile_token, :account_id, :user_id
  json.url subscription_url(subscription, format: :json)
end
