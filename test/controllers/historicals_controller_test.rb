require 'test_helper'

class HistoricalsControllerTest < ActionController::TestCase
  setup do
    @historical = historicals(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:historicals)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create historical" do
    assert_difference('Historical.count') do
      post :create, historical: { comment_id: @historical.comment_id, deal_id: @historical.deal_id, step_id: @historical.step_id, user_id: @historical.user_id }
    end

    assert_redirected_to historical_path(assigns(:historical))
  end

  test "should show historical" do
    get :show, id: @historical
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @historical
    assert_response :success
  end

  test "should update historical" do
    patch :update, id: @historical, historical: { comment_id: @historical.comment_id, deal_id: @historical.deal_id, step_id: @historical.step_id, user_id: @historical.user_id }
    assert_redirected_to historical_path(assigns(:historical))
  end

  test "should destroy historical" do
    assert_difference('Historical.count', -1) do
      delete :destroy, id: @historical
    end

    assert_redirected_to historicals_path
  end
end
