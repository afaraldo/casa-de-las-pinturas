require 'test_helper'

class ProveedoresControllerTest < ActionController::TestCase
  setup do
    @proveedore = proveedores(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:proveedores)
  end

  test "should get new" do
    get :load_form
    assert_response :success
  end

  test "should create proveedore" do
    assert_difference('Proveedore.count') do
      post :create, proveedore: {  }
    end

    assert_redirected_to proveedore_path(assigns(:proveedore))
  end

  test "should show proveedore" do
    get :show, id: @proveedore
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @proveedore
    assert_response :success
  end

  test "should update proveedore" do
    patch :update, id: @proveedore, proveedore: {  }
    assert_redirected_to proveedore_path(assigns(:proveedore))
  end

  test "should destroy proveedore" do
    assert_difference('Proveedore.count', -1) do
      delete :destroy, id: @proveedore
    end

    assert_redirected_to proveedores_path
  end
end
