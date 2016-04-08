class ComprasController < ApplicationController
  before_action :set_compra, only: [:show, :edit, :update, :destroy]
  before_action :setup_menu, only: [:index]

  # configuracion del menu
  def setup_menu
    @menu_setup[:main_menu] = :compras
    @menu_setup[:side_menu] = :compras_sidemenu
  end

  # GET /compras
  # GET /compras.json
  def index
    get_compras
  end

  # GET /compras/1
  # GET /compras/1.json
  def show
  end

  # GET /compras/new
  def new
    @compra = Compra.new
  end

  # GET /compras/1/edit
  def edit
  end

  # POST /compras
  # POST /compras.json
  def create
    @compra = Compra.new(compra_params)

    respond_to do |format|
      if @compra.save
        format.html { redirect_to @compra, notice: 'Compra was successfully created.' }
        format.json { render :show, status: :created, location: @compra }
      else
        format.html { render :new }
        format.json { render json: @compra.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /compras/1
  # PATCH/PUT /compras/1.json
  def update
    respond_to do |format|
      if @compra.update(compra_params)
        format.html { redirect_to @compra, notice: 'Compra was successfully updated.' }
        format.json { render :show, status: :ok, location: @compra }
      else
        format.html { render :edit }
        format.json { render json: @compra.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /proveedores/1
  # DELETE /proveedores/1.json
  def destroy
    if @compra.destroy
      @error = false
      @message = "Se ha eliminado la compra"
      get_proveedores
    else
      @error = true
      @message = "Ha ocurrido un problema al tratar de eliminar la compra"
    end

    render 'reload_list', format: :js
  end


  private

    def get_compras
      @search = Compra.search(params[:q])
      @compras = @search.result.includes(:proveedor).page(params[:page])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_compra
      @compra = Compra.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def compra_params
      params.require(:compra).permit(:persona_id, :numero, :numero_factura, :fecha, :fecha_vencimiento, :estado, :tipo, :condicion, :importe_total, :importe_pendiente, :importe_descontado)
    end
end
