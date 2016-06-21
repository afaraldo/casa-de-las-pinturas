require 'test_helper'

class PagosControllerTest < ActionController::TestCase
  setup do
    @pago = pagos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:pagos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create pago" do
    assert_difference('Pago.count') do
      post :create, pago: { deleted_at: @pago.deleted_at, fecha: @pago.fecha, numero: @pago.numero, tipo: @pago.tipo, total_credito_utilizado: @pago.total_credito_utilizado, total_efectivo: @pago.total_efectivo, total_tarjeta: @pago.total_tarjeta }
    end

    assert_redirected_to pago_path(assigns(:pago))
  end

  test "should show pago" do
    get :show, id: @pago
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @pago
    assert_response :success
  end

  test "should update pago" do
    patch :update, id: @pago, pago: { deleted_at: @pago.deleted_at, fecha: @pago.fecha, numero: @pago.numero, tipo: @pago.tipo, total_credito_utilizado: @pago.total_credito_utilizado, total_efectivo: @pago.total_efectivo, total_tarjeta: @pago.total_tarjeta }
    assert_redirected_to pago_path(assigns(:pago))
  end

  test "should destroy pago" do
    assert_difference('Pago.count', -1) do
      delete :destroy, id: @pago
    end

    assert_redirected_to pagos_path
  end
end
