class UsersController < ApplicationController

  before_action :authenticate_user!
  helper DeviseHelper

  helpers = %w(resource scope_name resource_name signed_in_resource
               resource_class resource_params devise_mapping)
  hide_action *helpers
  helper_method *helpers

  respond_to :html, :json, :js, :csv, :xls

  before_action :set_klass
  before_action :set_user, only: [ :show, :edit ]

  # Breadcrumbs
  # /dashboard/users
  before_action do
    add_breadcrumb :index, :users_path
  end

  # /user
  before_action only: [ :show, :edit ] do
    add_breadcrumb((@user.name || @user.id ), user_path(@user)) if @user
  end

  # ON COLLECTION

  def index
    @users = if current_user.admin?
      User.all.with_account_status
    else
      current_account.users.with_account_status
    end

    # respond_with @users
    respond_with(@users) do |format|
      format.csv { send_data @users.to_csv, filename: 'aircrm_users.csv' }
      format.xls { send_data @users.to_xls, filename: 'aircrm_users.xls' }
      # format.xls # { send_data @users.to_csv(col_sep: "\t") }
    end
  end

  # ON MEMBER

  def new
    @user = User.new
  end


  def create
    if User.where(user_params.slice(:email)).first
      flash[:alert] = "Usuário já cadastrado"
    else
      new_user = User.create(user_params)
      #force_authentication!(account, user)
      flash[:success] = "Usuário cadastrado com sucesso."
    end
    redirect_to user_signup_url
  end



  def show
    # if params[:id].blank?
    #   redirect_to(if current_user then profile_path(current_user) else new_user_session_url end)
    # else
    #   @user = User.find(params[:id])

    #   respond_with @user
    # end
  end

  def user_profile_plan
  end


  private

    # Short class
    def set_klass
      @klass = User
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_user
      user_id = params[:id] || params[:user_id] || current_user.id
      @user = @klass.unscoped.find(user_id)
    end



end
