require 'test_helper'

class BoletasControllerTest < ActionController::TestCase
  setup do
    @boleta = boletas(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:boletas)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create boleta" do
    assert_difference('Boleta.count') do
      post :create, boleta: { condicion: @boleta.condicion, estado: @boleta.estado, fecha: @boleta.fecha, fecha_vencimiento: @boleta.fecha_vencimiento, importe_descontado: @boleta.importe_descontado, importe_pendiente: @boleta.importe_pendiente, importe_total: @boleta.importe_total, numero: @boleta.numero, numero_factura: @boleta.numero_factura, persona_id: @boleta.persona_id, tipo: @boleta.tipo }
    end

    assert_redirected_to boleta_path(assigns(:boleta))
  end

  test "should show boleta" do
    get :show, id: @boleta
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @boleta
    assert_response :success
  end

  test "should update boleta" do
    patch :update, id: @boleta, boleta: { condicion: @boleta.condicion, estado: @boleta.estado, fecha: @boleta.fecha, fecha_vencimiento: @boleta.fecha_vencimiento, importe_descontado: @boleta.importe_descontado, importe_pendiente: @boleta.importe_pendiente, importe_total: @boleta.importe_total, numero: @boleta.numero, numero_factura: @boleta.numero_factura, persona_id: @boleta.persona_id, tipo: @boleta.tipo }
    assert_redirected_to boleta_path(assigns(:boleta))
  end

  test "should destroy boleta" do
    assert_difference('Boleta.count', -1) do
      delete :destroy, id: @boleta
    end

    assert_redirected_to boletas_path
  end
end
