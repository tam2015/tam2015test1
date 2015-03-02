module RoutesHelper

  def url_with_protocol(url)
    /^http/.match(url) ? url : "http://#{url}"
  end

  def full_asset_url(path)
    full_url asset_url(path)
  end

  def full_url(path="")
    "#{Rails.application.routes.url_helpers.root_url}#{path.gsub(/^\//, '')}"
  end

  # -------------------
  # exceptions rescue
  # -------------------

  #called by last route matching unmatched routes.  Raises RoutingError which will be rescued from in the same way as other exceptions.
  def raise_not_found!
    raise ActionController::RoutingError.new("No route matches #{params[:unmatched_route]}")
  end

  #render 500 error
  def render_error(e)
    render file: 'public/500.html', status: 500, layout: false
  end

  #render 404 error
  def render_not_found(e)
    # respond_to do |f|
    #   f.html{ render template: "errors/404", status: 404 }
    #   f.js{ render partial: "errors/ajax_404", status: 404 }
    # end

    render file: 'public/404.html', status: :not_found, layout: false
  end

  def render_not_authorized
    respond_to do |format|
      format.html { render file: 'public/401.html', status: :forbidden, layout: false }
      format.xml { render :json => "...", status: :forbidden }
    end
  end


  def after_sign_in_path_for(resource)
    super
  end

  # Overwriting the sign_out redirect path method
  def after_sign_out_path_for(resource_or_scope)
    user_session_path
  end

  def set_before_params
    session[:before_params        ] = params
  end

  def before_params
    session[:before_params]
  end

  def param_controller_is? controller_name, other_params=nil
    other_params ||= params

    other_params[:controller] == controller_name
  end

  def param_action_is? action_name, other_params=nil
    other_params ||= params

    other_params[:action] == action_name
  end

end
