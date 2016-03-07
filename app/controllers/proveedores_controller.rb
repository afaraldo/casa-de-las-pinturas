class ProveedoresController < ApplicationController
  before_action :set_proveedor, only: [:show, :edit, :update, :destroy]

  # GET /proveedores
  # GET /proveedores.json
  def index
    @proveedores = Proveedor.all
  end

  # GET /proveedores/1
  # GET /proveedores/1.json
  def show
  end

  # GET /proveedores/new
  def new
    @proveedor = Proveedor.new
    render 'load_form', format: :js
  end

  # GET /proveedores/1/edit
  def edit
    render 'load_form', format: :js
  end

  # POST /proveedores
  # POST /proveedores.json
  def create
    @proveedor = Proveedor.new(proveedor_params)

    if @proveedor.save
      @error = false
      @message = "Se ha guardado el proveedor"
      @proveedores = Proveedor.all
    else
      @error = true
      @message = "Ha ocurrido un problema al tratar de guardar el proveedor"
    end

    render 'reload_list', format: :js
  end

  # PATCH/PUT /proveedores/1
  # PATCH/PUT /proveedores/1.json
  def update

    if @proveedor.update(proveedor_params)
      @error = false
      @message = "Se ha guardado el proveedor"
      @proveedores = Proveedor.all
    else
      @error = true
      @message = "Ha ocurrido un problema al tratar de guardar el proveedor"
    end

    render 'reload_list', format: :js

  end

  # DELETE /proveedores/1
  # DELETE /proveedores/1.json
  def destroy
    if @proveedor.destroy
      @error = false
      @message = "Se ha eliminado el proveedor"
      @proveedores = Proveedor.all
    else
      @error = true
      @message = "Ha ocurrido un problema al tratar de eliminar el proveedor"
    end

    render 'reload_list', format: :js
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_proveedor
      @proveedor = Proveedor.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def proveedor_params
      params.require(:proveedor).permit(:nombre, :direccion, :telefono, :limite_credito)
    end
end
