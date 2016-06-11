class DevolucionVentasController < ApplicationController

  before_action :set_devolucion_venta, only: [:show, :edit, :update, :destroy]
  before_action :setup_menu, only: [:index, :new, :edit, :show, :create, :update]
  before_action :editable?, only: [:edit, :update]
  before_action :eliminable?, only: [:destroy]

  # configuracion del menu
  def setup_menu
    @menu_setup[:main_menu] = :ventas
    @menu_setup[:side_menu] = :devolucion_ventas_sidemenu
  end

  def editable?
    unless @devolucion_venta.es_editable?
      flash[:warning] = @devolucion_venta.no_editable_mensaje
      redirect_to @devolucion_venta
    end
  end

  def eliminable?
    unless @devolucion_venta.es_editable?
      flash[:warning] = @devolucion_venta.no_eliminable_mensaje
      redirect_to @devolucion_venta
    end
  end
  # GET /ventas
  # GET s.json
  def index
    get_devolucion_ventas
  end

  # GET /ventas/1
  # GET /ventas/1.json
  def show
  end

  # GET /ventas/new
  def new
    @devolucion_venta = DevolucionVenta.new
    #@devolucion_venta.detalles.build
    render :form
  end

  # GET /ventas/1/edit
  def edit
    render :form
  end

  # POST /ventas
  # POST /ventas.json
  def create
    @devolucion_venta = DevolucionVenta.new(devolucion_venta_params)
    @stock_negativo = params[:guardar_si_o_si].present? ? [] : @devolucion_venta.check_detalles_negativos
    respond_to do |format|
      DevolucionVenta.transaction do
        if @stock_negativo.size <= 0 && @devolucion_venta.save
          format.html { redirect_to @devolucion_venta, notice: t('mensajes.save_success', recurso: 'la devolución') }
          format.json { render :show, status: :created, location: @devolucion_venta }
        else
          #binding.pry
          format.html { render :form }
          format.json { render json: @devolucion_venta.errors, status: :unprocessable_entity }
        end
      end
    end

  end

  # PATCH/PUT /ventas/1
  # PATCH/PUT /ventas/1.json
  def update
    @stock_negativo = params[:guardar_si_o_si].present? ? [] : @devolucion_venta.check_detalles_negativos
    @devolucion_venta.assign_attributes(devolucion_venta_params)
    respond_to do |format|
      DevolucionVenta.transaction do
        if @stock_negativo.size <= 0 && @devolucion_venta.save
          format.html { redirect_to @devolucion_venta, notice: t('mensajes.save_success', recurso: 'la devolución') }
          format.json { render :index }
        else
          format.html { render :form }
          format.json { render json: @devolucion_venta.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /venta/1
  # DELETE /venta/1.json
  def destroy
    respond_to do |format|
      DevolucionVenta.transaction do
        if @devolucion_venta.destroy
          format.html { redirect_to devolucion_ventas_url, notice: t('mensajes.delete_success', recurso: 'la devolución') }
          format.json { head :no_content }
        else
          flash[:error] = t('mensajes.delete_error', errores: @devolucion_venta.errors.full_messages.to_sentence)
          format.html { redirect_to @devolucion_venta }
        end
      end
    end
  end
  def get_ventas
    @ventas = Venta.where("persona_id =?",params[:persona_id])
    respond_to do |format|
      format.json {render json: @ventas}
    end
  end

  def buscar_venta
    @venta_detalles = BoletaDetalle.where("boleta_id =?",params[:venta_id])
  end

  private

    def get_devolucion_ventas
      procesar_fechas
      @search = DevolucionVenta.search(params[:q])
      @devolucion_ventas = @search.result.includes(:persona).page(params[:page]).per(action_name == 'imprimir' ? LIMITE_REGISTROS_IMPRIMIR : 25)
    end
    # Setear las fechas "hasta" para que incluya el dia entero
    # 01/03/2016 => 2016-03-01 23:59:59
    def procesar_fechas
      if params[:q].present? && params[:q][:fecha_lt].present?
        params[:q][:fecha_lt] = params[:q][:fecha_lt].to_datetime.end_of_day
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_devolucion_venta
      @devolucion_venta = DevolucionVenta.find(params[:id])
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def devolucion_venta_params
      params.require(:devolucion_venta).permit(:persona_id, :motivo, :fecha,
                                   detalles_attributes: [:id,:mercaderia_id, :cantidad, :precio_unitario, :_destroy],
                                   boletas_detalles_attributes: [:id, :boleta_id, :_destroy])

    end


end