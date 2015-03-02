require 'test_helper'

class Providers::Mercadolibre::ShippingsControllerTest < ActionController::TestCase
  test "should get receiver" do
    get :receiver
    assert_response :success
  end

  # test "should update shipping" do
  #   patch :update, id: @shipping, shipping: { name: @shipping.name, description: @shipping.description, comment_id: @shipping.comment_id, step_id: @shipping.step_id, user_id: @shipping.user_id }
  #   assert_redirected_to shipping_path(assigns(:shipping))
  # end

end
