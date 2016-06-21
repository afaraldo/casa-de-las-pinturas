require 'test_helper'

class PagoDetallesControllerTest < ActionController::TestCase
  setup do
    @pago_detalle = pago_detalles(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:pago_detalles)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create pago_detalle" do
    assert_difference('PagoDetalle.count') do
      post :create, pago_detalle: { cotizacion: @pago_detalle.cotizacion, forma: @pago_detalle.forma, moneda_id: @pago_detalle.moneda_id, monto: @pago_detalle.monto, pago_id: @pago_detalle.pago_id }
    end

    assert_redirected_to pago_detalle_path(assigns(:pago_detalle))
  end

  test "should show pago_detalle" do
    get :show, id: @pago_detalle
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @pago_detalle
    assert_response :success
  end

  test "should update pago_detalle" do
    patch :update, id: @pago_detalle, pago_detalle: { cotizacion: @pago_detalle.cotizacion, forma: @pago_detalle.forma, moneda_id: @pago_detalle.moneda_id, monto: @pago_detalle.monto, pago_id: @pago_detalle.pago_id }
    assert_redirected_to pago_detalle_path(assigns(:pago_detalle))
  end

  test "should destroy pago_detalle" do
    assert_difference('PagoDetalle.count', -1) do
      delete :destroy, id: @pago_detalle
    end

    assert_redirected_to pago_detalles_path
  end
end
