class RegistrationsController < Devise::RegistrationsController

  respond_to :html, :js, :json
  prepend_before_filter :authenticate_scope!, only: [:edit, :update, :destroy, :account, :password, :new_invite]

  before_filter :configure_permitted_parameters, if: :devise_controller?


  def new
    super
  end

  def create
    super
    if resource.persisted?
    end
  end



  def new_invite
    @user = User.new
  end

  def create_user_from_invitation
    if user_account_owner?
      @user = User.create(sign_up_params)
      @user.account= current_user.account
      @user.save

      redirect_to dashboards_url
    end
  end

  protected

  def after_sign_up_path_for(resource)
    dashboards_url
  end

  def configure_permitted_parameters
    params_array = [
      # User details
      :first_name, :last_name, :username, :email, :phone, :role,
      # Password
      :password, :password_confirmation,
      # Assosiations
      :account_id ]

    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(*params_array)
    end
    devise_parameter_sanitizer.for(:account_update) do |u|
      params_array << :current_password
      u.permit(*params_array)
    end
  end
end
