class InvitationsController < Devise::InvitationsController

  respond_to :html, :json, :js

  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_filter :set_klass

  # Breadcrumbs
  # /dashboard/items
  before_action do
    add_breadcrumb :dashboards, dashboards_path
    add_breadcrumb :index, :invitations_path
  end

  def index
    Rails.logger.info "\n\n\n"
    Rails.logger.info " resource_class: #{resource_class}"
    Rails.logger.info "\n\n\n"

    @invitations = current_user.invitations
  end

  def create
    Rails.logger.info "\n\n\n"
    Rails.logger.info " invite_params: #{invite_params}"
    Rails.logger.info " invite_params[:file]: #{invite_params[:file]}"
    Rails.logger.info "\n\n\n"

    if invite_params[:file]
      User.import invite_params[:file], current_user

      flash[:alert] = "Usuários convidados com sucesso!"
      redirect_to invitations_path
    else
      super
    end
  end


  def import
    self.resource = resource_class.new
  end

  private

    # Short class
    def set_klass
      @klass = resource_class
    end

    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:invite).concat [:file]
    end
end
