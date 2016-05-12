class TransferenciasController < ApplicationController
  before_action :setup_menu, only: [:new, :create]

  # configuracion del menu
  def setup_menu
    @menu_setup[:main_menu] = :cajas
    @menu_setup[:side_menu] = :transferencias_sidemenu
  end

  # GET /caja_movimientos/new
  def new
    @movimiento_egreso = CajaMovimiento.new
    @moneda = Moneda.find_by_defecto(true)
    @movimiento_egreso.detalles.build(forma: :tarjeta, moneda_id: @moneda.id, cotizacion: @moneda.cotizacion )
    render :form
  end

  def create
    @movimiento_egreso = CajaMovimiento.new(caja_movimiento_params)
    @movimiento_egreso.motivo = "Transferencia de cuenta bancaria a caja registradora"
    @movimiento_egreso.tipo = :egreso
    @movimiento_egreso.caja_id = Caja.get_caja_por_forma(:tarjeta).id

    @movimiento_ingreso = CajaMovimiento.new(caja_movimiento_params)
    @movimiento_ingreso.motivo = "Transferencia de cuenta bancaria a caja registradora"
    @movimiento_ingreso.tipo = :ingreso
    @movimiento_ingreso.caja_id = Caja.get_caja_por_forma(:efectivo).id

    @saldo_negativo = params[:guardar_si_o_si].present? ? [] : @movimiento_egreso.check_detalles_negativos(false)


    respond_to do |format|
      CajaMovimiento.transaction do
        if @saldo_negativo.size == 0 && @movimiento_egreso.save && @movimiento_ingreso.save
          format.html { redirect_to @movimiento_ingreso, notice: t('mensajes.save_success', recurso: 'el movimiento') }
          format.json { render :show, status: :created, location: @movimiento_egreso }
        else
          format.html { render :form }
          format.json { render json: @movimiento_egreso.errors, status: :unprocessable_entity }
        end
      end
    end
    binding.pry
  end

  private
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
