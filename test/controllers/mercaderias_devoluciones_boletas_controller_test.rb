require 'test_helper'

class MercaderiasDevolucionesBoletasControllerTest < ActionController::TestCase
  setup do
    @mercaderias_devoluciones_boleta = mercaderias_devoluciones_boletas(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:mercaderias_devoluciones_boletas)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create mercaderias_devoluciones_boleta" do
    assert_difference('MercaderiasDevolucionesBoleta.count') do
      post :create, mercaderias_devoluciones_boleta: { boleta_id: @mercaderias_devoluciones_boleta.boleta_id }
    end

    assert_redirected_to mercaderias_devoluciones_boleta_path(assigns(:mercaderias_devoluciones_boleta))
  end

  test "should show mercaderias_devoluciones_boleta" do
    get :show, id: @mercaderias_devoluciones_boleta
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @mercaderias_devoluciones_boleta
    assert_response :success
  end

  test "should update mercaderias_devoluciones_boleta" do
    patch :update, id: @mercaderias_devoluciones_boleta, mercaderias_devoluciones_boleta: { boleta_id: @mercaderias_devoluciones_boleta.boleta_id }
    assert_redirected_to mercaderias_devoluciones_boleta_path(assigns(:mercaderias_devoluciones_boleta))
  end

  test "should destroy mercaderias_devoluciones_boleta" do
    assert_difference('MercaderiasDevolucionesBoleta.count', -1) do
      delete :destroy, id: @mercaderias_devoluciones_boleta
    end

    assert_redirected_to mercaderias_devoluciones_boletas_path
  end
end
