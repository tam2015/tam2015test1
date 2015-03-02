class WebhookController < ApplicationController

  skip_before_action  :verify_authenticity_token
  before_filter       :avoid_session

  # Mapping available providers
  @@providers = Webhook.providers.map(&:to_sym)

  respond_to :json

  def provider
    @provider_name = params[:provider].to_sym
    @notification  = params[:webhook]

    # Quit Request if provider is not available
    head :not_acceptable unless @@providers.include?(@provider_name)

    @webhook    = Webhook.new @provider_name, @notification
    @hook       = @webhook.instantiate_topic_class
    queue_id    = @hook.queue_notification

    Rails.logger.info "\n\n\n-- WebhookController -------------------------------------------- "
    Rails.logger.info "*** Provider: #{params[:provider]}"
    Rails.logger.info "*** Type: #{@notification[:topic].capitalize} "
    Rails.logger.info "*** Hook: #{@hook.class} - #{@hook} "
    Rails.logger.info "*** Hook Queue ID: #{queue_id} "
    Rails.logger.info "----------------------------------------------"

    # Notification stored
    head :ok
  end

  private

  def avoid_session
      Rails.logger.info "* Avoiding Session..."
      return unless request.format.json?
      request.session_options[:skip] = true
    end

end
