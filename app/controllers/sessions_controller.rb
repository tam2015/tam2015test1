class SessionsController < Devise::SessionsController
  layout "clean"

  respond_to :html, :js, :json

  def new
    super
  end

  def destroy
    super
  end
end
