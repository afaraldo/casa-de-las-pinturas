class ClientesController < ApplicationController
  before_action :set_cliente, only: [:show, :edit, :update, :destroy]
  before_action :setup_menu, only: [:index]

  # configuracion del menu
  def setup_menu
    @menu_setup[:main_menu] = :ventas
    @menu_setup[:side_menu] = :clientes_sidemenu
  end

  # buscador de proveedores
  def buscar
    get_clientes
    render json: {items: @clientes, total_count: @clientes.total_count}
  end

  # GET /clientes
  # GET /clientes.json
  def index
    get_clientes
  end

  # GET /clientes/1
  # GET /clientes/1.json
  def show
  end

  # GET /clientes/new
  def new
    @cliente = Cliente.new
    render 'load_form', format: :js
  end

  # GET /clientes/1/edit
  def edit
    render 'load_form', format: :js
  end

  # POST /clientes
  # POST /clientes.json
  def create
    @cliente = Cliente.new(cliente_params)

    if @cliente.save
      @error = false
      @message = "Se ha guardado el cliente"
      get_clientes
    else
      @error = true
      @message = "Ha ocurrido un problema al tratar de guardar el cliente. #{@cliente.errors.full_messages.to_sentence}"
    end

    render 'reload_list', format: :js
  end

  # PATCH/PUT /clientes/1
  # PATCH/PUT /clientes/1.json
  def update

    if @cliente.update(cliente_params)
      @error = false
      @message = "Se ha guardado el cliente"
      get_clientes
    else
      @error = true
      @message = "Ha ocurrido un problema al tratar de guardar el cliente. #{@cliente.errors.full_messages.to_sentence}"
    end

    render 'reload_list', format: :js

  end

  # DELETE /clientes/1
  # DELETE /clientes/1.json
  def destroy
    if @cliente.destroy
      @error = false
      @message = "Se ha eliminado el cliente"
      get_clientes
    else
      @error = true
      @message = "Ha ocurrido un problema al tratar de eliminar el cliente. #{@cliente.errors.full_messages.to_sentence}"
    end

    render 'reload_list', format: :js
  end

  # Comprobar si ya existe el proveedor con el nombre dado
  def check_nombre
    cliente = Cliente.by_nombre(params[:nombre]).first

    render json: (cliente.nil? || cliente.id == params[:id].to_i) ? true : t('cliente.unique_nombre_error', nombre: params[:nombre]).to_json
  end

  def get_clientes
    @search = Cliente.search(params[:q])
    @clientes = @search.result.page(params[:page])
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cliente
      @cliente = Cliente.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cliente_params
      params.require(:cliente).permit(:nombre, :telefono, :direccion, :numero_documento, :limite_credito)
    end
end
