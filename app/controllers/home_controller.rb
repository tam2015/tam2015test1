class HomeController < ApplicationController
  layout "home"
  skip_before_filter :check_subscription_expired
  
  def index
  end

  def about
  end

  def features
  end

  def services
  end

  def contact
  end

  def jobs
  end

  def terms
  end

  def guide
  end
end
