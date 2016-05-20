class VentasController < ApplicationController
  layout 'imprimir', only: [:imprimir]
  before_action :set_venta, only: [:show, :edit, :update, :destroy]
  before_action :setup_menu, only: [:index, :new, :edit, :show, :create, :update]

  # configuracion del menu
  def setup_menu
    @menu_setup[:main_menu] = :ventas
    @menu_setup[:side_menu] = :ventas_sidemenu
  end

  def buscar_devoluciones
    @cliente= Cliente.find(params[:persona_id])
    @devoluciones = @cliente.devoluciones_disponibles
  end

  def imprimir
    get_ventas
  end

  # GET /ventas
  # GET /ventas.json
  def index
    get_ventas
  end

  # GET /ventas/1
  # GET /ventas/1.json
  def show
    @stock_negativo = @venta.check_detalles_negativos(true)
  end

  # GET /ventas/new
  def new
    @venta = Venta.new
    @venta.detalles.build

    @recibo_detalle = @venta.recibos_detalles.build
    @cobro = @recibo_detalle.build_recibo
    @cobro.build_detalles

    render :form
  end

  # GET /ventas/1/edit
  def edit
    get_cobro
    render :form
  end

  # POST /ventas
  # POST /ventas.json
  def create
    nueva_venta
    respond_to do |format|
      Venta.transaction do
        if @venta.guardar(venta_params, params[:guardar_si_o_si].present?)
          format.html { redirect_to @venta, notice: t('mensajes.save_success', recurso: 'la venta') }
          format.json { render :show, status: :created, location: @venta }
        else
          get_cobro
          format.html { render :form }
          format.json { render json: @venta.errors, status: :unprocessable_entity }
        end
      end
    end

  end

  def nueva_venta
    @venta = Venta.new
  end

  # PATCH/PUT /ventas/1
  # PATCH/PUT /ventas/1.json
  def update
    respond_to do |format|
      Venta.transaction do
        if @venta.guardar(venta_params, params[:guardar_si_o_si].present?)
          format.html { redirect_to @venta, notice: t('mensajes.save_success', recurso: 'la venta') }
          format.json { render :show, status: :created, location: @venta }
        else
          get_cobro
          format.html { render :form }
          format.json { render json: @venta.errors, status: :unprocessable_entity }
        end
      end
    end

  end

  # DELETE /venta/1
  # DELETE /venta/1.json
  def destroy
    respond_to do |format|
      Venta.transaction do
        if @venta.destroy
          format.html { redirect_to ventas_url, notice: t('mensajes.delete_success', recurso: 'la venta') }
          format.json { head :no_content }
        else
          flash[:error] = t('mensajes.delete_error', recurso: 'la venta', errores: @venta.errors.full_messages.to_sentence)
          format.html { redirect_to @venta }
        end
      end
    end
  end

  private

    def get_ventas
      procesar_fechas
      @search = Venta.search(params[:q])
      @ventas = @search.result.includes(:persona, :detalles).page(params[:page]).per(action_name == 'imprimir' ? LIMITE_REGISTROS_IMPRIMIR : 25)
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_venta
      @venta = Venta.find(params[:id])
      @cobro = @venta.recibos.first
    end

    def get_cobro
      if @venta.recibos_detalles.first
        @cobro = @venta.recibos_detalles.first.recibo
        @cobro.rebuild_detalles if @cobro
      else
        @recibo_detalle = @venta.recibos_detalles.build
        @cobro = @recibo_detalle.build_recibo
        @cobro.build_detalles
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def venta_params
      procesar_cantidades_mercaderias
      procesar_cantidades_cobros
      procesar_devoluciones(params[:venta][:condicion])

      params[:venta].delete("recibos_detalles_attributes") if params[:venta][:condicion] == "credito"
      params.require(:venta).permit(:persona_id, :numero_comprobante, :fecha, :fecha_vencimiento, :estado, :condicion,
                                     recibos_detalles_attributes:[:id, :_destroy,
                                       recibo_attributes:  [:id, :fecha, :persona_id, :_destroy,
                                         detalles_attributes: [:id, :monto, :cotizacion, :moneda_id, :forma, :_destroy]
                                       ]
                                     ],
                                     creditos_detalles_attributes: [:id, :notas_creditos_debito_id, :monto_utilizado, :_destroy],
                                     detalles_attributes: [:id, :mercaderia_id, :cantidad, :precio_unitario, :_destroy],
                                     )
    end

    # Setear las fechas "hasta" para que incluya el dia entero
    # 01/03/2016 => 2016-03-01 23:59:59
    def procesar_fechas
      if params[:q].present? && params[:q][:fecha_lt].present?
        params[:q][:fecha_lt] = params[:q][:fecha_lt].to_datetime.end_of_day
      end
    end

    def procesar_cantidades_mercaderias
      params[:venta][:detalles_attributes].each do |i, d|
        params[:venta][:detalles_attributes][i][:cantidad] = cantidad_a_numero(d[:cantidad])
        params[:venta][:detalles_attributes][i][:precio_unitario] = cantidad_a_numero(d[:precio_unitario])
      end
    end

    def procesar_cantidades_cobros
      if params[:venta][:recibos_detalles_attributes]
        cobro = params[:venta][:recibos_detalles_attributes]["0"][:recibo_attributes]
        cobro[:detalles_attributes].each do |i, d|
          cobro[:detalles_attributes][i][:_destroy] = '1' if cantidad_a_numero(d[:monto]) == 0 # marcar para eliminar si el monto es cero
          cobro[:detalles_attributes][i][:monto] = cantidad_a_numero(d[:monto])
          cobro[:detalles_attributes][i][:cotizacion] = cantidad_a_numero(d[:cotizacion])
        end
      end
    end

    def procesar_devoluciones(condicion)
      if condicion == 'contado' && !params[:venta][:creditos_detalles_attributes].blank?
        params[:venta][:creditos_detalles_attributes].each do |k, valor|
          params[:venta][:creditos_detalles_attributes][k][:monto_utilizado] = cantidad_a_numero(valor[:monto_utilizado])
          # se eliminan de params las boletas que no se seleccionaron o se marcan para eliminar
          if valor[:id].present?
            params[:venta][:creditos_detalles_attributes][k][:_destroy] = '1' unless valor[:usado].present?
          else
            params[:venta][:creditos_detalles_attributes].delete(k) unless valor[:usado].present?
          end
        end
      else
        params[:venta].delete("creditos_detalles_attributes")
      end
    end
end
