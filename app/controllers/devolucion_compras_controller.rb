class DevolucionComprasController < ApplicationController

  before_action :set_devolucion_compra, only: [:show, :edit, :update, :destroy]
  before_action :setup_menu, only: [:index, :new, :edit, :show, :create, :update]
  before_action :editable?, only: [:edit, :update]
  before_action :eliminable?, only: [:destroy]

  # configuracion del menu
  def setup_menu
    @menu_setup[:main_menu] = :compras
    @menu_setup[:side_menu] = :devolucion_compras_sidemenu
  end

  def editable?
    unless @devolucion_compra.es_editable?
      flash[:warning] = @devolucion_compra.no_editable_mensaje
      redirect_to @devolucion_compra
    end
  end

  def eliminable?
    unless @devolucion_compra.es_editable?
      flash[:warning] = @devolucion_compra.no_eliminable_mensaje
      redirect_to @devolucion_compra
    end
  end

  # GET /compras
  # GET /compras.json
  def index
    get_devolucion_compras
  end

  # GET /compras/1
  # GET /compras/1.json
  def show
  end

  # GET /compras/new
  def new
    @devolucion_compra = DevolucionCompra.new
    #@devolucion_compra.detalles.build
    render :form
  end

  # GET /compras/1/edit
  def edit
    render :form
  end

  # POST /compras
  # POST /compras.json
  def create
    @devolucion_compra = DevolucionCompra.new(devolucion_compra_params)
    @stock_negativo = params[:guardar_si_o_si].present? ? [] : @devolucion_compra.check_detalles_negativos
    respond_to do |format|
      DevolucionCompra.transaction do
        if @stock_negativo.size <= 0 && @devolucion_compra.save
          format.html { redirect_to @devolucion_compra, notice: t('mensajes.save_success', recurso: 'la devolución') }
          format.json { render :show, status: :created, location: @devolucion_compra }
        else
          #binding.pry
          format.html { render :form }
          format.json { render json: @devolucion_compra.errors, status: :unprocessable_entity }
        end
      end
    end

  end

  # PATCH/PUT /compras/1
  # PATCH/PUT /compras/1.json
  def update
    @stock_negativo = params[:guardar_si_o_si].present? ? [] : @devolucion_compra.check_detalles_negativos
    @devolucion_compra.assign_attributes(devolucion_compra_params)
    respond_to do |format|
      DevolucionCompra.transaction do
        if @stock_negativo.size <= 0 && @devolucion_compra.save
          format.html { redirect_to @devolucion_compra, notice: t('mensajes.save_success', recurso: 'la devolución') }
          format.json { render :index }
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
      DevolucionCompra.transaction do
        if @devolucion_compra.destroy
          format.html { redirect_to devolucion_compras_url, notice: t('mensajes.delete_success', recurso: 'la devolución') }
          format.json { head :no_content }
        else
          flash[:error] = t('mensajes.delete_error', errores: @devolucion_compra.errors.full_messages.to_sentence)
          format.html { redirect_to @devolucion_compra }
        end
      end
    end
  end
  def get_compras
    @compras = Compra.where("persona_id =?",params[:persona_id])
    respond_to do |format|
      format.json {render json: @compras}
    end
  end

  def buscar_compra
    @compra_detalles = BoletaDetalle.where("boleta_id =?",params[:compra_id])
  end

  private

    def get_devolucion_compras
      procesar_fechas
      @search = DevolucionCompra.search(params[:q])
      @devolucion_compras = @search.result.includes(:persona).page(params[:page]).per(action_name == 'imprimir' ? LIMITE_REGISTROS_IMPRIMIR : 25)
    end
    # Setear las fechas "hasta" para que incluya el dia entero
    # 01/03/2016 => 2016-03-01 23:59:59
    def procesar_fechas
      if params[:q].present? && params[:q][:fecha_lt].present?
        params[:q][:fecha_lt] = params[:q][:fecha_lt].to_datetime.end_of_day
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_devolucion_compra
      @devolucion_compra = DevolucionCompra.find(params[:id])
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def devolucion_compra_params
      params.require(:devolucion_compra).permit(:persona_id, :motivo, :fecha,
                                   detalles_attributes: [:id,:mercaderia_id, :cantidad, :precio_unitario],
                                   boletas_detalles_attributes: [:id, :boleta_id, :_destroy])

    end


end
