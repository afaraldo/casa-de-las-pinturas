class DevolucionComprasController < ApplicationController
  layout 'imprimir', only: [:imprimir]
  before_action :set_devolucion_compra, only: [:show, :edit, :update, :destroy]
  before_action :setup_menu, only: [:index, :new, :edit, :show, :create, :update]

  # configuracion del menu
  def setup_menu
    @menu_setup[:main_menu] = :compras
    @menu_setup[:side_menu] = :devolucion_compra_sidemenu
  end

  # GET /compras
  # GET /compras.json
  def index
    get_devolucion_compras
  end

  # GET /compras/1
  # GET /compras/1.json
  def show
    @stock_negativo = @devolucion_compra.check_detalles_negativos(true)
  end

  # GET /compras/new
  def new
    @devolucion_compra = DevolucionCompra.new
    render :form
  end

  # GET /compras/1/edit
  def edit
    render :form
  end

  # POST /compras
  # POST /compras.json
  def create
    #binding.pry
    @devolucion_compra = Compra.new(compra_params)

    respond_to do |format|
      Compra.transaction do
        if @devolucion_compra.save
          format.html { redirect_to @devolucion_compra, notice: t('mensajes.save_success', recurso: 'la compra') }
          format.json { render :show, status: :created, location: @devolucion_compra }
        else
          format.html { render :form }
          format.json { render json: @devolucion_compra.errors, status: :unprocessable_entity }
        end
      end
    end

  end

  # PATCH/PUT /compras/1
  # PATCH/PUT /compras/1.json
  def update
    @devolucion_compra.assign_attributes(compra_params)
    @stock_negativo = params[:guardar_si_o_si].present? ? [] : @devolucion_compra.check_detalles_negativos
    respond_to do |format|
      Compra.transaction do
        if @stock_negativo.size <= 0 && @devolucion_compra.save
          format.html { redirect_to @devolucion_compra, notice: t('mensajes.save_success', recurso: 'la compra') }
          format.json { render :show, status: :created, location: @devolucion_compra }
        else
          format.html { render :form }
          format.json { render json: @devolucion_compra.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /compra/1
  # DELETE /compra/1.json
  def destroy
    respond_to do |format|
      Compra.transaction do
        if @devolucion_compra.destroy
          format.html { redirect_to compras_url, notice: t('mensajes.delete_success', recurso: 'la compra') }
          format.json { head :no_content }
        else
          flash[:error] = t('mensajes.delete_error', recurso: 'la compra', errores: @devolucion_compra.errors.full_messages.to_sentence)
          format.html { redirect_to @devolucion_compra }
        end
      end
    end
  end

  private

    def get_devolucion_compras
      @search = DevolucionCompra.search(params[:q])
      @devolucion_compras = @search.result.page(params[:page])
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_compra
      @devolucion_compra = Compra.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def devolucion_compra_params
      procesar_cantidades
      params.require(:devolucion_compra).permit(:persona_id, :numero, :fecha, :motivo
                                     detalles_attributes: [:id, :mercaderia_id, :cantidad, :precio_unitario, :_destroy])
    end

    end

end
