# Preview all emails at http://localhost:3000/rails/mailers/mailing/notify
class Mailing::NotifyPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/mailing/notify/no_address
  def no_address
    Mailing::Notify.no_address
  end

  # Preview this email at http://localhost:3000/rails/mailers/mailing/notify/welcome
  def welcome
    user = User.current
    Mailing::Notify.welcome user
  end

end
