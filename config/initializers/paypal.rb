  PayPal::Recurring.configure do |config|
    config.sandbox    = ENV['PAYPAL_SANDBOX']
    config.username   = ENV['PAYPAL_USERNAME']
    config.password   = ENV['PAYPAL_PASSWORD']
    config.signature  = ENV['PAYPAL_SIGNATURE']
  end

