require 'test_helper'

class BoletaDetallesControllerTest < ActionController::TestCase
  setup do
    @boleta_detalle = boleta_detalles(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:boleta_detalles)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create boleta_detalle" do
    assert_difference('BoletaDetalle.count') do
      post :create, boleta_detalle: { boleta_id: @boleta_detalle.boleta_id, cantidad: @boleta_detalle.cantidad, mercaderia_id: @boleta_detalle.mercaderia_id, precio_unitario: @boleta_detalle.precio_unitario }
    end

    assert_redirected_to boleta_detalle_path(assigns(:boleta_detalle))
  end

  test "should show boleta_detalle" do
    get :show, id: @boleta_detalle
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @boleta_detalle
    assert_response :success
  end

  test "should update boleta_detalle" do
    patch :update, id: @boleta_detalle, boleta_detalle: { boleta_id: @boleta_detalle.boleta_id, cantidad: @boleta_detalle.cantidad, mercaderia_id: @boleta_detalle.mercaderia_id, precio_unitario: @boleta_detalle.precio_unitario }
    assert_redirected_to boleta_detalle_path(assigns(:boleta_detalle))
  end

  test "should destroy boleta_detalle" do
    assert_difference('BoletaDetalle.count', -1) do
      delete :destroy, id: @boleta_detalle
    end

    assert_redirected_to boleta_detalles_path
  end
end
