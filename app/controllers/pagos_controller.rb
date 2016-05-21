class PagosController < ApplicationController
  layout 'imprimir', only: [:imprimir]

  before_action :set_pago, only: [:show, :edit, :update, :destroy]

  before_action :setup_menu, only: [:index, :new, :edit, :show, :create, :update]

  # configuracion del menu
  def setup_menu
    @menu_setup[:main_menu] = :compras
    @menu_setup[:side_menu] = :pagos_sidemenu
  end

  # busca las compras y devoluciones pendientes de un proveedor dado
  def buscar_pendientes
    @proveedor = Proveedor.find(params[:proveedor_id])
    @compras = @proveedor.compras_pendientes
    @devoluciones = @proveedor.devoluciones_disponibles
  end

  def imprimir
    get_pagos
  end

  # GET /pagos
  # GET /pagos.json
  def index
    get_pagos
  end

  # GET /pagos/1
  # GET /pagos/1.json
  def show
  end

  # GET /pagos/new
  def new
    @pago = Pago.new
    @pago.build_detalles
    render :form
  end

  # GET /pagos/1/edit
  def edit
    @pago.rebuild_detalles
    render :form
  end

  # POST /pagos
  # POST /pagos.json
  def create
    @pago = Pago.new(pago_params)
    @pago.condicion = "credito"
    @saldo_negativo = params[:guardar_si_o_si].present? ? [] : @pago.check_detalles_negativos

    respond_to do |format|
      Pago.transaction do
        if @saldo_negativo.size == 0 && @pago.save
          format.html { redirect_to @pago, notice: t('mensajes.save_success', recurso: 'el pago') }
          format.json { render :show, status: :created, location: @pago }
        else
          @pago.rebuild_detalles
          format.html { render :form }
          format.json { render json: @pago.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /pagos/1
  # PATCH/PUT /pagos/1.json
  def update
    @pago.assign_attributes(pago_params)
    @pago.condicion = "credito"
    @saldo_negativo = params[:guardar_si_o_si].present? ? [] : @pago.check_detalles_negativos

    respond_to do |format|
      Pago.transaction do
        if @saldo_negativo.size == 0 && @pago.save
          format.html { redirect_to @pago, notice: t('mensajes.update_success', recurso: 'el pago') }
          format.json { render :show, status: :ok, location: @pago }
        else
          @pago.rebuild_detalles
          format.html { render :form }
          format.json { render json: @pago.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /pagos/1
  # DELETE /pagos/1.json
  def destroy
    @pago.destroy
    respond_to do |format|
      format.html { redirect_to pagos_url, notice: t('mensajes.delete_success', recurso: 'el pago') }
      format.json { head :no_content }
    end
  end

  private
    def get_pagos
      procesar_fechas
      @search = Pago.search(params[:q])
      @pagos = @search.result.includes(:persona).page(params[:page]).per(action_name == 'imprimir' ? LIMITE_REGISTROS_IMPRIMIR : 25)
    end

    # Setear las fechas "hasta" para que incluya el dia entero
    # 01/03/2016 => 2016-03-01 23:59:59
    def procesar_fechas
      if params[:q].present? && params[:q][:fecha_lt].present?
        params[:q][:fecha_lt] = params[:q][:fecha_lt].to_datetime.end_of_day
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_pago
      @pago = Pago.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def pago_params

      procesar_cantidades
      # se eliminan de params las boletas que no se seleccionaron o se marcan para eliminar
      params[:pago][:boletas_detalles_attributes].each do |k, valor|
        if valor[:id].present?
          params[:pago][:boletas_detalles_attributes][k][:_destroy] = '1' unless valor[:pagado].present?
        else
          params[:pago][:boletas_detalles_attributes].delete(k) unless valor[:pagado].present?
        end
      end

      params.require(:pago).permit(:persona_id, :numero_comprobante, :fecha,
                                   detalles_attributes: [:id, :monto, :cotizacion, :moneda_id, :forma, :_destroy],
                                   boletas_detalles_attributes: [:id, :monto_utilizado, :boleta_id, :_destroy])

    end

    def procesar_cantidades
      params[:pago][:detalles_attributes].each do |i, d|
        params[:pago][:detalles_attributes][i][:_destroy] = '1' if cantidad_a_numero(d[:monto]) == 0 # marcar para eliminar si el monto es cero
        params[:pago][:detalles_attributes][i][:monto] = cantidad_a_numero(d[:monto])
        params[:pago][:detalles_attributes][i][:cotizacion] = cantidad_a_numero(d[:cotizacion])
      end
    end

end
