class CobrosController < ApplicationController
  layout 'imprimir', only: [:imprimir, :imprimir_show]

  before_action :set_cobro, only: [:show, :imprimir_show, :edit, :update, :destroy]

  before_action :setup_menu, only: [:index, :new, :edit, :show, :create, :update]

  # configuracion del menu
  def setup_menu
    @menu_setup[:main_menu] = :ventas
    @menu_setup[:side_menu] = :cobros_sidemenu
  end

  # busca las ventas y devoluciones pendientes de un cliente dado
  def buscar_pendientes
    @cliente = Cliente.find(params[:cliente_id])
    @ventas = @cliente.ventas_pendientes
    @devoluciones = @cliente.devoluciones_disponibles
  end

  def imprimir
    get_cobros
  end

  def imprimir_show
  end

  # GET /cobros
  # GET /cobros.json
  def index
    get_cobros
  end

  # GET /pagos/1
  # GET /pagos/1.json
  def show
  end

  # GET /cobros/new
  def new
    @cobro = Cobro.new
    @cobro.build_detalles
    render :form
  end

  # GET /cobros/1/edit
  def edit
    @cobro.rebuild_detalles
    render :form
  end

  # POST /cobros
  # POST /cobros.json
  def create
    @cobro = Cobro.new(cobro_params)
    @saldo_negativo = params[:guardar_si_o_si].present? ? [] : @cobro.check_detalles_negativos

    respond_to do |format|
      Cobro.transaction do
        if @saldo_negativo.size == 0 && @cobro.save
          format.html { redirect_to @cobro, notice: t('mensajes.save_success', recurso: 'el cobro') }
          format.json { render :show, status: :created, location: @cobro }
        else
          @cobro.rebuild_detalles
          format.html { render :form }
          format.json { render json: @cobro.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /cobros/1
  # PATCH/PUT /cobros/1.json
  def update
    @cobro.assign_attributes(cobro_params)
    @saldo_negativo = params[:guardar_si_o_si].present? ? [] : @cobro.check_detalles_negativos

    respond_to do |format|
      Cobro.transaction do
        if @saldo_negativo.size == 0 && @cobro.save
          format.html { redirect_to @cobro, notice: t('mensajes.update_success', recurso: 'el cobro') }
          format.json { render :show, status: :ok, location: @cobro }
        else
          @cobro.rebuild_detalles
          format.html { render :form }
          format.json { render json: @cobro.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /cobros/1
  # DELETE /cobros/1.json
  def destroy
    @cobro.destroy
    respond_to do |format|
      format.html { redirect_to cobros_url, notice: t('mensajes.delete_success', recurso: 'el cobro') }
      format.json { head :no_content }
    end
  end

  private
    def get_cobros
      procesar_fechas
      @search = Cobro.search(params[:q])
      @cobros = @search.result.includes(:persona).page(params[:page]).per(action_name == 'imprimir' ? LIMITE_REGISTROS_IMPRIMIR : 25)
    end

    # Setear las fechas "hasta" para que incluya el dia entero
    # 01/03/2016 => 2016-03-01 23:59:59
    def procesar_fechas
      if params[:q].present? && params[:q][:fecha_lt].present?
        params[:q][:fecha_lt] = params[:q][:fecha_lt].to_datetime.end_of_day
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_cobro
      @cobro = Cobro.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cobro_params

      procesar_cantidades

      # se eliminan de params las boletas que no se seleccionaron o se marcan para eliminar
      params[:cobro][:boletas_detalles_attributes].each do |k, valor|
        if valor[:id].present?
          params[:cobro][:boletas_detalles_attributes][k][:_destroy] = '1' unless valor[:pagado].present?
        else
          params[:cobro][:boletas_detalles_attributes].delete(k) unless valor[:pagado].present?
        end
        end

      # se eliminan los creditos que no se seleccionaron para utilizar
      unless params[:cobro][:recibos_creditos_detalles_attributes].blank?
        params[:cobro][:recibos_creditos_detalles_attributes].each do |k, valor|
          if valor[:id].present?
            params[:cobro][:recibos_creditos_detalles_attributes][k][:_destroy] = '1' unless valor[:usado].present?
          else
            params[:cobro][:recibos_creditos_detalles_attributes].delete(k) unless valor[:usado].present?
          end
        end
      end

      params.require(:cobro).permit(:persona_id, :numero_comprobante, :fecha,
                                   detalles_attributes: [:id, :monto, :cotizacion, :moneda_id, :forma, :_destroy],
                                   boletas_detalles_attributes: [:id, :monto_utilizado, :boleta_id, :_destroy],
                                   recibos_creditos_detalles_attributes: [:id, :notas_creditos_debito_id, :monto_utilizado, :_destroy],
                                   )
    end

    def procesar_cantidades
      params[:cobro][:detalles_attributes].each do |i, d|
        params[:cobro][:detalles_attributes][i][:_destroy] = '1' if cantidad_a_numero(d[:monto]) == 0 # marcar para eliminar si el monto es cero
        params[:cobro][:detalles_attributes][i][:monto] = cantidad_a_numero(d[:monto])
        params[:cobro][:detalles_attributes][i][:cotizacion] = cantidad_a_numero(d[:cotizacion])
      end
    end

end
