class Mailing::Subscription < ActionMailer::Base
  default from: ENV["MAIL_DEFAULT_FROM"]

  def subscription_confirmation(subscription)
    user = User.where(id: subscription.user_id).first
    @user = user
    #attachments["rails.png"] = File.read("#{Rails.root}/public/images/rails.png")
    mail(:to => "#{user.name} <#{user.email}>", :subject => "Confirmação de assinatura")
  end
end
