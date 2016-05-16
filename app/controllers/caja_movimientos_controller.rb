class CajaMovimientosController < ApplicationController
  before_action :set_caja_movimiento, only: [:show, :edit, :update, :destroy]
  before_action :setup_menu, only: [:index, :new, :edit, :show, :create, :update]

  # configuracion del menu
  def setup_menu
    @menu_setup[:main_menu] = :cajas
    @menu_setup[:side_menu] = :caja_movimientos_sidemenu
  end

  # GET /caja_movimientos
  # GET /caja_movimientos.json
  def index
    get_caja_movimientos
  end

  # GET /caja_movimientos/1
  # GET /caja_movimientos/1.json
  def show
  end

  # GET /caja_movimientos/new
  def new
    @caja_movimiento = CajaMovimiento.new
    @caja_movimiento.build_detalles
    render :form
  end

  # GET /caja_movimientos/1/edit
  def edit
    render :form
  end

  # POST /caja_movimientos
  # POST /caja_movimientos.json
  def create
    @caja_movimiento = CajaMovimiento.new(caja_movimiento_params)
    @saldo_negativo = params[:guardar_si_o_si].present? ? [] : @caja_movimiento.check_detalles_negativos

    respond_to do |format|
      CajaMovimiento.transaction do
        if @saldo_negativo.size == 0 && @caja_movimiento.save
          format.html { redirect_to @caja_movimiento, notice: t('mensajes.save_success', recurso: 'el movimiento') }
          format.json { render :show, status: :created, location: @caja_movimiento }
        else
          @caja_movimiento.rebuild_detalles
          format.html { render :form }
          format.json { render json: @caja_movimiento.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /caja_movimientos/1
  # PATCH/PUT /caja_movimientos/1.json
  def update
    @caja_movimiento.assign_attributes(caja_movimiento_params)
    @saldo_negativo = params[:guardar_si_o_si].present? ? [] : @caja_movimiento.check_detalles_negativos

    respond_to do |format|
      CajaMovimiento.transaction do
        if @saldo_negativo.size == 0 && @caja_movimiento.save
          format.html { redirect_to @caja_movimiento, notice: t('mensajes.update_success', recurso: 'el movimiento') }
          format.json { render :show, status: :ok, location: @caja_movimiento }
        else
          @caja_movimiento.rebuild_detalles
          format.html { render :form }
          format.json { render json: @caja_movimiento.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /caja_movimientos/1
  # DELETE /caja_movimientos/1.json
  def destroy
    respond_to do |format|
      CajaMovimiento.transaction do
        if @caja_movimiento.destroy
          format.html { redirect_to caja_movimientos_url, notice: t('mensajes.delete_success', recurso: 'el movimiento') }
          format.json { head :no_content }
        else
          flash[:error] = t('mensajes.delete_error', recurso: 'el movimiento', errores: @caja_movimiento.errors.full_messages.to_sentence)
          format.html { redirect_to @caja_movimiento }
        end
      end
    end
  end

  def get_caja_movimientos(caja = nil)
    @caja_movimientos = nil

    # Configurando las fechas
    @desde = nil
    @hasta = nil

    if params[:fecha_desde].present? && params[:fecha_hasta].present?
      @desde = params[:fecha_desde].to_datetime
      @hasta = params[:fecha_hasta].to_datetime
    end

    # buscar movimientos
    @caja_id = !params[:caja_id].blank? ? params[:caja_id] : Caja.get_caja_por_forma(:efectivo).id
    if caja
      @caja_id = Caja.get_caja_por_forma(caja).id
    end
    @moneda_id = !params[:moneda_id].blank? ? params[:moneda_id] : Moneda.first.id
    @caja_movimientos = CajaExtracto.get_movimientos(caja_id: @caja_id, moneda_id: @moneda_id,
                                                             desde: @desde,
                                                             hasta: @hasta,
                                                             page: params[:page],
                                                             limit: action_name == 'imprimir_extracto' ? LIMITE_REGISTROS_IMPRIMIR : nil)
    end

    # GET /caja_movimientos/new
    def new_transferencia
      @movimiento_egreso = CajaMovimiento.new
      @moneda = Moneda.find_by_defecto(true)
      @movimiento_egreso.detalles.build(forma: :tarjeta, moneda_id: @moneda.id, cotizacion: @moneda.cotizacion )
      render 'load_form', format: :js
    end

    def create_transferencia
      CajaMovimiento.transaction do
        @result = CajaMovimiento.guardar_transferencia(params[:fecha], params[:monto], params[:guardar_si_o_si].present?)
        unless @result.size > 0
          @error = false
          @message = "Se ha guardado la transferencia"
          get_caja_movimientos :tarjeta
        else
          @error = true
          @message = "Ha ocurrido un problema al tratar de guardar la transferencia. #{@result.to_sentence}"
        end
      end
      render 'reload_list', format: :js
    end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_caja_movimiento
      @caja_movimiento = CajaMovimiento.find(params[:id])
    end

    def caja_movimiento_params
      procesar_cantidades
      params.require(:caja_movimiento).permit(:fecha, :motivo, :tipo, :categoria_gasto_id,
                                                    detalles_attributes: [:id, :forma, :moneda_id, :monto, :cotizacion, :_destroy])
    end

    def procesar_cantidades
      params[:caja_movimiento][:detalles_attributes].each do |i, d|
        params[:caja_movimiento][:detalles_attributes][i][:monto] = cantidad_a_numero(d[:monto])
        params[:caja_movimiento][:detalles_attributes][i][:cotizacion] = cantidad_a_numero(d[:cotizacion])
      end
    end

end
