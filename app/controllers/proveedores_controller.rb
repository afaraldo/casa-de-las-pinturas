class ProveedoresController < ApplicationController
  before_action :set_proveedor, only: [:show, :edit, :update, :destroy]
  before_action :setup_menu, only: [:index]

  # configuracion del menu
  def setup_menu
    @menu_setup[:main_menu] = :compras
    @menu_setup[:side_menu] = :proveedores_sidemenu
  end

  # buscador de proveedores
  def buscar
    get_proveedores
    render json: {items: @proveedores, total_count: @proveedores.total_count}
  end

  # GET /proveedores
  # GET /proveedores.json
  def index
    get_proveedores
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
      get_proveedores
    else
      @error = true
      @message = "Ha ocurrido un problema al tratar de guardar el proveedor. #{@proveedor.errors.full_messages.to_sentence}"
    end

    render 'reload_list', format: :js
  end

  # PATCH/PUT /proveedores/1
  # PATCH/PUT /proveedores/1.json
  def update

    if @proveedor.update(proveedor_params)
      @error = false
      @message = "Se ha guardado el proveedor"
      get_proveedores
    else
      @error = true
      @message = "Ha ocurrido un problema al tratar de guardar el proveedor. #{@proveedor.errors.full_messages.to_sentence}"
    end

    render 'reload_list', format: :js

  end

  # DELETE /proveedores/1
  # DELETE /proveedores/1.json
  def destroy
    if @proveedor.destroy
      @error = false
      @message = "Se ha eliminado el proveedor"
      get_proveedores
    else
      @error = true
      @message = "Ha ocurrido un problema al tratar de eliminar el proveedor"
    end

    render 'reload_list', format: :js
  end

  # Comprobar si ya existe el proveedor con el nombre dado
  def check_nombre
    proveedor = Proveedor.by_nombre(params[:nombre]).first

    render json: (proveedor.nil? || proveedor.id == params[:id].to_i) ? true : t('proveedor.unique_nombre_error', nombre: params[:nombre]).to_json
  end

  def get_proveedores
    @search = Proveedor.search(params[:q])
    @proveedores = @search.result.page(params[:page])
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_proveedor
      @proveedor = Proveedor.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def proveedor_params
      procesar_monto
      params.require(:proveedor).permit(:id, :nombre, :direccion, :numero_documento, :telefono, :limite_credito)
    end

    def procesar_monto
      params[:proveedor][:limite_credito] = cantidad_a_numero(params[:proveedor][:limite_credito])
    end
end
