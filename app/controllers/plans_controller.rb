class PlansController < ApplicationController

  skip_before_filter :check_subscription_expired
  layout "home"

  def index
    @plans = Plan.all
  end

  private

    def plan_params
      params.require(:plan).permit(:name, :price, :collaborator, :dashboard)
    end
end
