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
    render 'load_form', format: :js
  end

  def create
    @movimiento_egreso = CajaMovimiento.new(caja_movimiento_params)
    CajaMovimiento.transaction do
      if @movimiento_egreso.save
        @error = false
        @message = "Se ha guardado la transferencia"
      else
        @error = true
        @message = "Ha ocurrido un problema al tratar de guardar la transferencia. #{@movimiento_egreso.errors.full_messages.to_sentence}"
      end
    end
    render 'reload_list', format: :js
  end

  private
    def caja_movimiento_params

      params.require(:caja_movimiento).permit(:fecha, :motivo, :tipo, :categoria_gasto_id,
                                                    detalles_attributes: [:id, :forma, :moneda_id, :monto, :cotizacion, :_destroy])
    end
end
