class ReportsController < ApplicationController

  def orders_without_address
    # @orders ||= Box.where(ml_shipping_address: nil, user: current_user)
    @orders ||= Box.where(user: current_user)
  end

end
