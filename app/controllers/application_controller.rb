class ApplicationController < ActionController::Base
  include ApplicationHelper

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  around_filter :set_currents
  before_filter :set_before_params, only: [ :index, :show, :new, :edit ]
  before_filter :check_subscription_expired

  # -------------------
  # Error routes rescue
  # http://blog.yangtheman.com/2012/10/11/user-friendly-500-and-404-pages-on-rails-3/
  # -------------------
  # if Rails.env.production?
  #   unless Rails.application.config.consider_all_requests_local
  #     # 500 - Error
  #     rescue_from Exception , with: :render_error

  #     # 401 - Not Authorized
  #     rescue_from CanCan::AccessDenied                , with: :render_not_authorized

  #     # 404 - not found
  #     rescue_from ActiveRecord::RecordNotFound                      , with: :render_not_found
  #     rescue_from ActionController::RoutingError                    , with: :render_not_found
  #     rescue_from ActionController::UnknownController               , with: :render_not_found
  #     rescue_from Mongoid::Errors::DocumentNotFound                 , with: :render_not_found
  #     rescue_from ActiveSupport::MessageVerifier::InvalidSignature  , with: :render_not_found
  #   end
  # end

  layout :disable_layout_for_xhr

  def disable_layout_for_xhr
    (!!request.xhr?) ? false : "application"
  end

  def set_flash_errors(resource, options = {})
    unless options[:scope].nil?
      flash[options[:scope]] = { error: resource.errors.full_messages }
    else
      flash[:warning] = resource.errors.full_messages
    end
  end

  before_filter :_set_current_session

  protected

  def _set_current_session
    # Define an accessor. The session is always in the current controller
    # instance in @_request.session. So we need a way to access this in
    # our model
    accessor = instance_variable_get(:@_request)

    # This defines a method session in ActiveRecord::Base. If your model
    # inherits from another Base Class (when using MongoMapper or similar),
    # insert the class here.
    ActiveRecord::Base.send(:define_method, "session", proc {accessor.session})
  end

  def trial_period_checked
    trial_period_reverse_count = ((current_account.created_at + 14.days).to_date - Date.today).round

    if trial_period_reverse_count <= 0 && current_account.payment_notifications.count == 0
      redirect_to plans_index_url
    end
  end

  def set_currents
    Account.current= current_account
    User.current= current_user

    current_dashboard

    yield
    ensure
      # to address the thread variable leak issues in Puma/Thin webserver
      Account.current= nil
      User.current= nil
    end

  end

