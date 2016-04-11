require 'test_helper'

class ComprasControllerTest < ActionController::TestCase
  setup do
    @compra = compras(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:compras)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create compra" do
    assert_difference('Compra.count') do
      post :create, compra: { condicion: @compra.condicion, estado: @compra.estado, fecha: @compra.fecha, fecha_vencimiento: @compra.fecha_vencimiento, importe_descontado: @compra.importe_descontado, importe_pendiente: @compra.importe_pendiente, importe_total: @compra.importe_total, numero: @compra.numero, numero_factura: @compra.numero_factura, persona_id: @compra.persona_id, tipo: @compra.tipo }
    end

    assert_redirected_to compra_path(assigns(:compra))
  end

  test "should show compra" do
    get :show, id: @compra
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @compra
    assert_response :success
  end

  test "should update compra" do
    patch :update, id: @compra, compra: { condicion: @compra.condicion, estado: @compra.estado, fecha: @compra.fecha, fecha_vencimiento: @compra.fecha_vencimiento, importe_descontado: @compra.importe_descontado, importe_pendiente: @compra.importe_pendiente, importe_total: @compra.importe_total, numero: @compra.numero, numero_factura: @compra.numero_factura, persona_id: @compra.persona_id, tipo: @compra.tipo }
    assert_redirected_to compra_path(assigns(:compra))
  end

  test "should destroy compra" do
    assert_difference('Compra.count', -1) do
      delete :destroy, id: @compra
    end

    assert_redirected_to compras_path
  end
end
