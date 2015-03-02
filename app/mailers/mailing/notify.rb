class Mailing::Notify < ActionMailer::Base
  default from: ENV["MAIL_DEFAULT_FROM"]

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.mailing.notify.no_address.subject
  #
  def no_address(notify_id)
    return if !set_notify(notify_id)
    return if !set_reference

    @sender   = @notify.sender || NotifyAgent.new
    @receiver = @notify.receiver
    @token    = @reference.generate_token

    @notify.update({
      status:             :delivered,
      email_delivered_at: Time.current
      })

    mail headers
  end


  def welcome(user)
    @user = user
    #attachments["rails.png"] = File.read("#{Rails.root}/public/images/rails.png")
    mail({
      subject: "Seja bem vindo ao AirCRM",
      to: "#{@user.name} <#{@user.email}>"
    })
  end

  protected

  def headers(opts={})
    headers = {
      subject: "Seu pedido está sem endereço",
      to: @receiver.email,
      from: (@sender.email || default_params[:from])#,
      # reply_to: mailer_reply_to(devise_mapping),
      # template_path: template_paths,
      # template_name: action
    }.merge(opts)

    @email = headers[:to]
    headers
  end

  private

  def set_reference()
    @reference = @notify.reference_model.constantize.find(@notify.reference_id)
  end

  def set_notify(notify_id)
    @notify = Notify.find(notify_id)
  end

end
