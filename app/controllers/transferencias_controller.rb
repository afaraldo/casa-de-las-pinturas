class TransferenciasController < ApplicationController
  before_action :setup_menu, only: [:new, :create]

  # configuracion del menu
  def setup_menu
    @menu_setup[:main_menu] = :cajas
    @menu_setup[:side_menu] = :transferencias_sidemenu
  end

  

  private
    def caja_movimiento_params

      params.require(:caja_movimiento).permit(:fecha, :motivo, :tipo, :categoria_gasto_id,
                                                    detalles_attributes: [:id, :forma, :moneda_id, :monto, :cotizacion, :_destroy])
    end
end
