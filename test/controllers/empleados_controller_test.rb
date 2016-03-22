require 'test_helper'

class EmpleadosControllerTest < ActionController::TestCase
  setup do
    @empleado = empleados(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:empleados)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create empleado" do
    assert_difference('Empleado.count') do
      post :create, empleado: { direccion: @empleado.direccion, nombre: @empleado.nombre, ruc: @empleado.ruc, telefono: @empleado.telefono }
    end

    assert_redirected_to empleado_path(assigns(:empleado))
  end

  test "should show empleado" do
    get :show, id: @empleado
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @empleado
    assert_response :success
  end

  test "should update empleado" do
    patch :update, id: @empleado, empleado: { direccion: @empleado.direccion, nombre: @empleado.nombre, ruc: @empleado.ruc, telefono: @empleado.telefono }
    assert_redirected_to empleado_path(assigns(:empleado))
  end

  test "should destroy empleado" do
    assert_difference('Empleado.count', -1) do
      delete :destroy, id: @empleado
    end

    assert_redirected_to empleados_path
  end
end
