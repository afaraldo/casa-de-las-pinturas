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

    respond_to do |format|
      CajaMovimiento.transaction do
        if @caja_movimiento.save
          format.html { redirect_to @caja_movimiento, notice: t('mensajes.save_success', recurso: 'el movimiento') }
          format.json { render :show, status: :created, location: @caja_movimiento }
        else
          format.html { render :form }
          format.json { render json: @caja_movimiento.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /caja_movimientos/1
  # PATCH/PUT /caja_movimientos/1.json
  def update
    respond_to do |format|
      CajaMovimiento.transaction do
        if @caja_movimiento.update(caja_movimiento_params)
          format.html { redirect_to @caja_movimiento, notice: t('mensajes.update_success', recurso: 'el movimiento') }
          format.json { render :show, status: :ok, location: @caja_movimiento }
        else
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

  def get_caja_movimientos
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
    @moneda_id = !params[:moneda_id].blank? ? params[:moneda_id] : Moneda.first.id
    @caja_movimientos = CajaExtracto.get_movimientos(caja_id: @caja_id, moneda_id: @moneda_id,
                                                             desde: @desde,
                                                             hasta: @hasta,
                                                             page: params[:page],
                                                             limit: action_name == 'imprimir_extracto' ? LIMITE_REGISTROS_IMPRIMIR : nil)
    end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_caja_movimiento
      @caja_movimiento = CajaMovimiento.find(params[:id])
    end

    def caja_movimiento_params
      procesar_cantidades
      params.require(:caja_movimiento).permit(:fecha, :motivo, :tipo,
                                                    detalles_attributes: [:id, :forma, :moneda_id, :monto, :destroy])
    end

    def procesar_cantidades
      params[:caja_movimiento][:detalles_attributes].each do |i, d|
        params[:caja_movimiento][:detalles_attributes][i][:monto] = cantidad_a_numero(d[:monto])
      end
    end

  # Setear las fechas "hasta" para que incluya el dia entero
  # 01/03/2016 => 2016-03-01 23:59:59
  def procesar_fechas
    if params[:q].present? && params[:q][:fecha_lt].present?
      params[:q][:fecha_lt] = params[:q][:fecha_lt].to_datetime.end_of_day
    end
  end

end