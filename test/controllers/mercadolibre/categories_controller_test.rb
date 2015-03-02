require 'test_helper'

class Mercadolibre::CategoriesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get show" do
    get :show
    assert_response :success
  end

  test "should get suggest" do
    get :suggest
    assert_response :success
  end

end
